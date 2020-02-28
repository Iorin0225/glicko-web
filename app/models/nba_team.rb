# frozen_string_literal: true

class NbaTeam < ApplicationRecord
  has_many :nba_game_results
end
