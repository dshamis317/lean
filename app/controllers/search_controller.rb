class SearchController < ApplicationController
  def index
    @topics = Topic.all
  end

  def search
    term = params[:search].downcase
    topic = params[:topics].to_i
    urls = Feed.get_feed_urls(topic)
    search_results = Feed.create_news_source_objects(urls, term)
    scores = Search.get_sentiment_scores(search_results)
    historical_data = Search.compile_historical_data(term, topic)
    data_object = Search.compile_data_for_search(search_results, scores, historical_data)
    Search.save_data_to_db(scores, term, topic)
    render :json => data_object.to_json
  end

  def save
    search = params[:search].downcase
    topic = params[:topic].to_i
    urls = Feed.get_feed_urls(topic)
    search_results = Feed.create_news_source_objects(urls, search)
    scores = Search.get_sentiment_scores(search_results)
    Search.save_data_to_db(scores, search, topic)
    render :json => scores.to_json
  end

  def ticker
    data = HTTParty.get('http://hawttrends.appspot.com/api/terms/')
    ticker = data['1']
    render :json => ticker.to_json
  end
end
