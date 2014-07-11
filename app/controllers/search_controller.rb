class SearchController < ApplicationController
  def index
    @topics = Topic.all
  end

  def search
    search = params[:search]
    topic = params[:topics].to_i
    db_feeds = Feed.where("topic_id = ?", topic)
    urls = []
    db_feeds.each do |feed|
      urls << feed.url
    end
    feeds = Feedjira::Feed.fetch_and_parse urls
    keys = feeds.keys
    search_results = []
    keys.each do |key|
      source = {}
      source[:title] ||= feeds[key].title
      source[:description] = feeds[key].description
      source[:site_url] = feeds[key].feed_url
      source[:modified] = feeds[key].last_modified
      source[:stories] = []
      feeds[key].entries.each do |feed|
        if feed.title.downcase.include?(search.downcase)
          data = HTTParty.get("http://access.alchemyapi.com/calls/url/URLGetTextSentiment?apikey=e0f145265967a4aa21013b7107bf8a834dc9ffa2&url=#{feed.url}&outputMode=json&showSourceText=1")
          if data['text']
            story = {}
            story[:title] = feed.title
            story[:story_url] = feed.url
            story[:sentiment_type] = data['docSentiment']['type']
            story[:sentiment_score] =data['docSentiment']['score']
            source[:stories] << story
          end
        end
      end
      search_results << source
    end
    redirect_to root_path
  end
end
