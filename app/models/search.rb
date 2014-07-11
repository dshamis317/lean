class Search < ActiveRecord::Base
  belongs_to :user
  has_many :histories
  has_many :feeds, through => :histories
end
