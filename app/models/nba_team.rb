# frozen_string_literal: true

class NbaTeam < ApplicationRecord
  has_many :nba_game_results

  attr_accessor :rating

  DEFAULT_RATING = 1500
  DEFAULT_DEVIATION = 350
  DEFAULT_VOLARITY = 0.06

  Rating = Struct.new(:rating, :rating_deviation, :volatility)

  def rating
    Rating.new(glicko_rating, glicko_deviation, glicko_volarity)
  end

  def self.initialize_rating(rating: DEFAULT_RATING,
                             deviation: DEFAULT_DEVIATION,
                             volarity: DEFAULT_VOLARITY)

    NbaTeam.update_all(glicko_rating: rating,
                       glicko_deviation: deviation,
                       glicko_volarity: volarity,
                       win_count: 0,
                       lose_count: 0,
                       draw_count: 0)
  end

  def self.show_all
    NbaTeam.pluck :name, :win_count, :lose_count, :draw_count, :glicko_rating, :glicko_deviation, :glicko_volarity
  end
end
