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
    search_term = params[:search]
    topic = params[:topic].to_i
    scores = params[:scores]
    score_data = Search.parse_sentiment_data(scores)
    binding.pry
  end
end
