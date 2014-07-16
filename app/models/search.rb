class Search < ActiveRecord::Base
  has_many :histories
  has_many :feeds, through: :histories

  def self.parse_sentiment_data(array)
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

end
