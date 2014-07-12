class User < ActiveRecord::Base
  authenticates_with_sorcery!
  has_many :searches

  validates :email, :presence => true,
                    :uniqueness => true,
                    # :email => true,
                    :format => {with: /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/,
                                message: "Please enter a valid email",
                                :on => :create}

  validates :password, :presence => true,
                       :confirmation => true,
                       :length => {within: 6..14,
                                   too_short: "is too short, it needs to be between 6 and 14 characters",
                                   too_long: "is too long, it needs to be between 6 and 14 characters",
                                   :on => :create}
end

