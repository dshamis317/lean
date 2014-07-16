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
    initial_object = Search.compile_for_d3_object(search.histories).values
    secondary_object = Search.parse_data_object(initial_object).values
    dates = secondary_object.map {|day| day[:date].to_i}
    max = dates.max.to_s
    min = dates.min.to_s
    feeds = Feed.where(topic_id: topic).map(&:name)
    final_object = (min..max).map do |date|
      hash = {}
      hash[:date] = date
      feeds.each do |publication|
        current_date = secondary_object.find{|obj| obj[:date] == date }
        current_sentiment = current_date ? (current_date[publication] || 0) : 0
        hash[publication] = current_sentiment
      end
      hash
    end
    render :json => final_object.to_json
  end

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
