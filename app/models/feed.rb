class Feed < ActiveRecord::Base
  belongs_to :topic

  API_KEY = ENV.fetch('ALCHEMY')

  def self.get_feed_urls(id)
    db_feeds = Feed.where("topic_id = ?", id)
    urls = []
    db_feeds.each do |feed|
      urls << feed.url
    end
    return urls
  end

  def self.create_news_source_objects(array, search_term)
    search = search_term
    feeds = Feedjira::Feed.fetch_and_parse array
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
          data = HTTParty.get("http://access.alchemyapi.com/calls/url/URLGetTextSentiment?apikey=#{API_KEY}&url=#{feed.url}&outputMode=json&showSourceText=1")
          if data
            if data['text'].present?
              story = {}
              story[:title] = feed.title
              story[:story_url] = feed.url
              story[:sentiment_type] = data['docSentiment']['type']
              story[:sentiment_score] = data['docSentiment']['score']
              source[:stories] << story
            end
          end
        end
      end
      search_results << source
    end
    return search_results
  end

end
