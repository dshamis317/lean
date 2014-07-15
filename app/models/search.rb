class Search < ActiveRecord::Base
  has_many :histories
  has_many :feeds, through: :histories

  def self.parse_sentiment_data(array)
    scores = array
    keys = scores.keys
    formatted_scores = []
    keys.each do |key|
      score = []
      score << scores[key]['name']
      score << scores[key]['value']
      formatted_scores << score
    end
    return formatted_scores
  end
end
