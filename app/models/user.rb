class User < ApplicationRecord

  has_many :holdings
  has_many :stocks, through: :holdings

  has_many :posts

  has_many :relationships,  class_name:  "Relationship",
                                   foreign_key: "follower_id",
                                   dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy
  has_many :following, through: :relationships,  source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  before_save { email.downcase! }
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
		    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }

   # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def UpdateAccountValue(current_user)
    holdings = Holding.where(:user => current_user)
    holdings_value = 0
    holdings.each do |holding|
      if (holding[:type_of_holding] == 'buy')
        holdings_value = holdings_value + (holding[:quantity] * holding.stock[:current_price])
      else #(q * i) - (q(c - i))
        holdings_value = holdings_value + ((holding[:quantity] * holding[:price_at_purchase]) -
            (holding[:quantity] * (holding.stock[:current_price] - holding[:price_at_purchase])))
      end
    end
    #current_user.update_column :account_value, (holdings_value + current_user.cash)
    current_user.account_value = holdings_value + current_user.cash
    current_user.save(validate: false)
  end 
  
end
