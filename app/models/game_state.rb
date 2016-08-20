class GameState < ActiveRecord::Base
    serialize :board
end
