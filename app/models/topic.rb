class Topic < ActiveRecord::Base
  has_many :feeds
end
