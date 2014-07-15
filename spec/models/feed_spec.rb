require 'spec_helper'

describe Feed do
  describe 'it can find urls' do

    before :each do
      @sports = Topic.new
      @sports.name = 'Sports'
      @sports.save

      @espn = Feed.new
      @espn.name = "ESPN"
      @espn.url = "http://www.espn.com"
      @espn.topic_id = @sports.id
      @end
    end

    it 'responds successfully' do
      actual = response.code
      expected = '200'
      expect(actual).to eq(expected)
    end

    it 'returns urls' do
      actual = Feed.get_feed_urls(@sports.id)
      expected = ["http://www.espn.com"]
      expect(actual).to eq(expected)
    end

  end
end
