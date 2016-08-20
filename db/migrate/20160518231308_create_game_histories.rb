class CreateGameHistories < ActiveRecord::Migration
  def change
    create_table :game_histories do |t|
      t.belongs_to :user, index: true
      t.belongs_to :problem, index: true
      t.boolean :success
      t.timestamps null: false
    end
  end
end
