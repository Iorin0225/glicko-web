# frozen_string_literal: true

class NbaGameResult < ApplicationRecord
  belongs_to :team_a, class_name: 'NbaTeam'
  belongs_to :team_b, class_name: 'NbaTeam'

  def apply_team_score
    if score_a > score_b
      team_a.win_count = team_a.win_count + 1
      team_b.lose_count = team_b.lose_count + 1
    elsif score_a < score_b
      team_b.win_count = team_b.win_count + 1
      team_a.lose_count = team_a.lose_count + 1
    else
      team_a.draw_count = team_a.draw_count + 1
      team_b.draw_count = team_b.draw_count + 1
    end
    team_a.save
    team_b.save
  end
end
