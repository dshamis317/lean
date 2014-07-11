class SearchController < ApplicationController
  def index
    @topics = Topic.all
  end

  def search
  end
end
