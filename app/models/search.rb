class Search < ActiveRecord::Base
  has_many :histories
  has_many :feeds, through: :histories

  def self.get_sentiment_scores(array)
    data = []
    array.each do |news_source|
      stories = news_source[:stories]
      if stories.length > 0
        scores = []
        stories.each do |story|
          if story[:sentiment_score] == 'null'
            scores << 0.5.to_f
          else
            scores << ((story[:sentiment_score].to_f + 1) * 0.5).to_f
          end
        end
        counter = 0
        sum = 0
        scores.each do |score|
          sum += score
          counter += 1
        end
        data << {name:news_source[:title], value: (sum/counter).to_f}
      end
    end
    return data
  end

  def self.compile_data_for_search(results_array, scores_array, history_array)
    data = {}
    data[:search_results] = results_array
    data[:scores] = scores_array
    data[:historical_data] = history_array
    return data
  end

  def self.compile_historical_data(term, topic)
    search = Search.find_or_create_by({keyword: term, topic_id: topic})
    initial_object = Search.compile_for_d3_object(search.histories).values
    secondary_object = Search.parse_data_object(initial_object).values
    dates = secondary_object.map {|day| day[:date].to_i}
    max = dates.max.to_s
    min = dates.min.to_s
    feeds = Feed.where(topic_id: topic).map(&:name)
    historical_data = (min..max).map do |date|
      hash = {}
      hash[:date] = date
      feeds.each do |publication|
        current_date = secondary_object.find{|obj| obj[:date] == date }
        current_sentiment = current_date ? (current_date[publication] || 0) : 0
        hash[publication] = current_sentiment
      end
      hash
    end
    return historical_data
  end

  def self.parse_sentiment_data_for_search(array)
    scores = array
    if scores.present?
      keys = scores.keys
      formatted_scores = []
      keys.each do |key|
        score = []
        score << scores[key]['name']
        score << scores[key]['value']
        formatted_scores << score
      end
      return formatted_scores
    else
      return nil
    end
  end

  def self.parse_sentiment_data_for_save(array)
    scores = array
    if scores.present?
      formatted_scores = []
      scores.each do |score|
        sentiment = []
        sentiment << score[:name]
        sentiment << score[:value].to_f
        formatted_scores << sentiment
      end
      return formatted_scores
    else
      return nil
    end
  end

  def self.compile_for_d3_object(array)
    arr = array.each_with_object({}) do |array, hash|
      key = array.date+array.feed_name
      hash[key] ||= {}
      hash[key][:date] = array.date
      hash[key][:feed_name] = array.feed_name
      hash[key][:sentiments] ||= []
      hash[key][:sentiments] << array.sentiment
      hash[key][:sentiment] = hash[key][:sentiments].reduce(0, &:+).to_f / hash[key][:sentiments].length
    end
    return arr
  end

  def self.parse_data_object(array)
    arr = array.each_with_object({}) do |result, hash|
      hash[result[:date]] ||= {}
      hash[result[:date]][:date] ||= result[:date]
      hash[result[:date]][result[:feed_name]] = result[:sentiment]
    end
    return arr
  end

  def self.save_data_to_db(scores, search, topic)
    score_data = Search.parse_sentiment_data_for_save(scores)
    searched = Search.find_or_create_by({keyword: search, topic_id: topic})
    if score_data.present?
      score_data.each do |score|
        history = History.create({search_id: searched.id, feed_name: score[0], sentiment: score[1].to_f, date: Time.now.strftime("%Y%m%d")})
        searched.histories << history
      end
    end
  end

end
