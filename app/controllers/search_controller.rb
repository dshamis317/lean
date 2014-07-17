class SearchController < ApplicationController
  def index
    @topics = Topic.all
  end

  def search
    term = params[:search].downcase
    topic = params[:topics].to_i
    urls = Feed.get_feed_urls(topic)
    search_results = Feed.create_news_source_objects(urls, term)
    scores = Search.get_sentiment_scores_for_search(search_results)
    historical_data = Search.compile_historical_data(term, topic)
    data_object = Search.compile_data_for_search(search_results, scores, historical_data)
    render :json => data_object.to_json
  end

  def save
    search = params[:search].downcase
    topic = params[:topic].to_i
    urls = Feed.get_feed_urls(topic)
    search_results = Feed.create_news_source_objects(urls, search)
    scores = Search.get_sentiment_scores(search_results)
    score_data = Search.parse_sentiment_data_for_save(scores)
    searched = Search.find_or_create_by({keyword: search, topic_id: topic})
    if score_data.present?
      score_data.each do |score|
        history = History.create({search_id: searched.id, feed_name: score[0], sentiment: score[1].to_f, date: Time.now.strftime("%Y%m%d")})
        searched.histories << history
      end
    end
    render :json => searched.to_json
  end

  def ticker
    data = HTTParty.get('http://hawttrends.appspot.com/api/terms/')
    ticker = data['1']
    render :json => ticker.to_json
  end
end
