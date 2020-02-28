# frozen_string_literal: true

class CreateNbaGameResults < ActiveRecord::Migration[6.0]
  def change
    create_table :nba_game_results do |t|
      t.references :team_a, null: false, index: true, foreign_key: { to_table: :nba_teams }
      t.references :team_b, null: false, index: true, foreign_key: { to_table: :nba_teams }
      t.integer :score_a, null: false, default: 0
      t.integer :score_b, null: false, default: 0
      t.datetime :game_at, null: false

      t.timestamps
    end
  end
end
