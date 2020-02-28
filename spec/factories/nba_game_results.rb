# frozen_string_literal: true

FactoryBot.define do
  factory :nba_game_result do
    reference { '' }
    reference { '' }
    score_a { 1 }
    score_b { 1 }
    game_at { '2020-02-28 10:49:09' }
  end
end
