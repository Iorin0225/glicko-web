# frozen_string_literal: true

class CreateNbaTeams < ActiveRecord::Migration[6.0]
  def change
    create_table :nba_teams do |t|
      t.string :name, null: false
      t.string :key, null: false, unique: true
      t.string :icon_url, null: false

      t.timestamps
    end
  end
end
