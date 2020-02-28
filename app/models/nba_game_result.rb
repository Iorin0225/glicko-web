# frozen_string_literal: true

class NbaGameResult < ApplicationRecord
  belongs_to :team_a, class_name: 'NbaTeam'
  belongs_to :team_b, class_name: 'NbaTeam'
end
