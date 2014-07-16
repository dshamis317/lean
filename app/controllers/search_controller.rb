class SearchController < ApplicationController
  def index
    @topics = Topic.all
  end

  def search
    search = params[:search]
    topic = params[:topics].to_i
    urls = Feed.get_feed_urls(topic)
    search_results = Feed.create_news_source_objects(urls, search)
    render :json => search_results.to_json
  end

  def history
    term = params[:search_term].downcase
    topic = params[:topic_id].to_i
    search = Search.find_by({keyword: term, topic_id: topic})
    resultz = search.histories.each_with_object({}) do |search_history, hash|
      key = search_history.date+search_history.feed_name
      hash[key] ||= {}
      hash[key][:date] = search_history.date
      hash[key][:feed_name] = search_history.feed_name
      hash[key][:sentiments] ||= []
      hash[key][:sentiments] << search_history.sentiment
      hash[key][:sentiment] = hash[key][:sentiments].reduce(0, &:+).to_f / hash[key][:sentiments].length
    end.values
    intermediate_data_set = resultz.each_with_object({}) do |result, hash|
      hash[result[:date]] ||= {}
      hash[result[:date]][:date] ||= result[:date]
      hash[result[:date]][result[:feed_name]] = result[:sentiment]
    end.values

    dates = intermediate_data_set.map do |day|
      day[:date].to_i
    end

    max = dates.max.to_s
    min = dates.min.to_s
    feeds = Feed.where(topic_id: topic).map(&:name)

    set_of_sentiments_for_each_feed_for_topic_sorted_by_date = (min..max).map do |date|
      hash = {}
      hash[:date] = date
      feeds.each do |publication|
        data_set_at_current_date = intermediate_data_set.find{|obj| obj[:date] == date }
        sentiment_for_current_date_for_publication = data_set_at_current_date ? (data_set_at_current_date[publication] || 0) : 0
        hash[publication] = sentiment_for_current_date_for_publication
      end
      hash
    end

    # bad_name = final.sort_by { |data_points_by_date| data_points_by_date[:date] }
    # feeds = Feed.where(topic_id: topic).pluck(:name)

    # bad_name.each do |data_points_by_date|
    #   ensure_all_feeds_exist(data_points_by_date, feeds)
    # end

    render :json => set_of_sentiments_for_each_feed_for_topic_sorted_by_date.to_json
  end

  # def ensure_all_feeds_exist(data_points, feeds)
  #   feeds.each do |feed|
  #     data_points[feed] ||= 0
  #   end

  #   data_points
  # end

  def save
    search = params[:search].downcase
    topic = params[:topic].to_i
    scores = params[:scores]
    score_data = Search.parse_sentiment_data(scores)
    searched = Search.find_or_create_by({keyword: search, topic_id: topic})
    if score_data.present?
      score_data.each do |score|
        history = History.create({search_id: searched.id, feed_name: score[0], sentiment: score[1].to_f, date: Time.now.strftime("%Y%m%d")})
        searched.histories << history
      end
    end
    render :json => searched.to_json
  end
end
