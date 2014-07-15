require 'spec_helper'

describe SearchController do
  describe 'given topic' do

    before :each do
      @sports = Topic.new
      @sports.name = 'Sports'
      @sports.save
    end

    describe 'GET index' do

      before :each do
        get :index
      end

      it 'responds successfully' do
        actual = response.code
        expected = '200'
        expect(actual).to eq(expected)
      end

      it 'assigns @topics' do
        actual = assigns(:topics)
        expected = [@sports]
        expect(actual).to eq(expected)
      end

    end # GET index
  end
end
