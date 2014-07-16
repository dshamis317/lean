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
    resultz = search.histories.each_with_object({}) do |histori, hash|
      key = histori.date+histori.feed_name
      hash[key] ||= {}
      hash[key][:date] = histori.date
      hash[key][:feed_name] = histori.feed_name
      hash[key][:sentiments] ||= []
      hash[key][:sentiments] << histori.sentiment
      hash[key][:sentiment] = hash[key][:sentiments].reduce(0, &:+).to_f / hash[key][:sentiments].length
    end.values
    final = resultz.each_with_object({}) do |result, hash|
      hash[result[:date]] ||= {}
      hash[result[:date]][:date] ||= result[:date]
      hash[result[:date]][result[:feed_name]] = result[:sentiment]
    end.values

    dates = final.map do |day|
      day[:date].to_i
    end

    max = dates.max.to_s
    min = dates.min.to_s

    bad_name = (min..max).map do |date|
      hash = {}
      hash[:date] = date
      Feed.where(topic_id: topic).map(&:name).uniq.each do |publication|
        hash[publication] = final.select{|obj| obj[:date] == date }[0][publication] || 0
      end
      hash
    end

    render :json => bad_name.to_json
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
