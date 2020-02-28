# frozen_string_literal: true

class CreateNbaTeams < ActiveRecord::Migration[6.0]
  def change
    create_table :nba_teams do |t|
      t.string :name, null: false
      t.string :key, null: false, unique: true
      t.string :icon_url, null: false
      t.float :glicko_rating, default: 0.00, null: false
      t.float :glicko_deviation, default: 0.00, null: false
      t.float :glicko_volarity, default: 0.00, null: false
      t.integer :win_count, default: 0, null: false
      t.integer :lose_count, default: 0, null: false
      t.integer :draw_count, default: 0, null: false
      t.timestamps
    end
  end
end
