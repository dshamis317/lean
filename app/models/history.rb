class History < ActiveRecord::Base
  belongs_to :feed
  belongs_to :search
end
