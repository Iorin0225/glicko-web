# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20_200_228_014_909) do
  create_table 'nba_game_results', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC', force: :cascade do |t|
    t.bigint 'team_a_id', null: false
    t.bigint 'team_b_id', null: false
    t.integer 'score_a', default: 0, null: false
    t.integer 'score_b', default: 0, null: false
    t.datetime 'game_at', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['team_a_id'], name: 'index_nba_game_results_on_team_a_id'
    t.index ['team_b_id'], name: 'index_nba_game_results_on_team_b_id'
  end

  create_table 'nba_teams', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC', force: :cascade do |t|
    t.string 'name', null: false
    t.string 'key', null: false
    t.string 'icon_url', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  add_foreign_key 'nba_game_results', 'nba_teams', column: 'team_a_id'
  add_foreign_key 'nba_game_results', 'nba_teams', column: 'team_b_id'
end
