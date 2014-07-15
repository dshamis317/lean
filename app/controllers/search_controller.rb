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
  end

  def save
    search = params[:search].downcase
    topic = params[:topic].to_i
    scores = params[:scores]
    score_data = Search.parse_sentiment_data(scores)
    searched = Search.find_or_create_by({keyword: search, topic_id: topic})
    score_data.each do |score|
      history = History.create({search_id: searched.id, feed_name: score[0], sentiment: score[1].to_f})
      searched.histories << history
    end
    render :json => searched.to_json
  end
end
