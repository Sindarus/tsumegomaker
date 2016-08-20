class Problem < ActiveRecord::Base
  has_many :game_histories
  has_many :users, through: :game_histories
end
