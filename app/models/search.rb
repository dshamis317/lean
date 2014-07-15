class Search < ActiveRecord::Base
  has_many :histories
  has_many :feeds, through => :histories
end
