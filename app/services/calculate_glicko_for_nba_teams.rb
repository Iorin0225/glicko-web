# frozen_string_literal: true

class CalculateGlickoForNbaTeams
  # ActiveRecord::Base.logger = nil

  def initialize; end

  def calc_per_season
    NbaTeam.initialize_rating

    team_objs = {}
    NbaTeam.find_each do |nba_team|
      team_objs[nba_team.key.to_sym] = nba_team.rating
    end
    period = Glicko2::RatingPeriod.from_objs(team_objs)

    NbaGameResult.order(:game_at).each do |nba_game_result|
      team_a = nba_game_result.team_a
      team_b = nba_game_result.team_b

      period.game(
        [team_a.key, team_b.key],
        [-1 * nba_game_result.score_a, -1 * nba_game_result.score_b]
      )

      period = period.generate_next(0.5)
      period.players.each(&:update_obj)

      puts "#{team_a.key}(#{nba_game_result.score_a}) VS #{team_b.key}(#{nba_game_result.score_b})"
      puts "#{team_a.key}: #{period.player(team_a.key.to_sym).obj.rating}"
      puts "#{team_b.key}: #{period.player(team_b.key.to_sym).obj.rating}"
      # if team_a.key == 'TOR' || team_b.key == 'TOR'
      #   puts "#{team_a.key}(#{nba_game_result.score_a}) VS #{team_b.key}(#{nba_game_result.score_b})"
      # end
      # if team_a.key == 'TOR'
      #   puts "#{team_a.key}: #{period.player(team_a.key.to_sym).obj.rating}"
      # end
      # if team_b.key == 'TOR'
      #   puts "#{team_b.key}: #{period.player(team_b.key.to_sym).obj.rating}"
      # end

      nba_game_result.apply_team_score
    end

    # Output updated Glicko ratings
    period.players.each do |player|
      NbaTeam.where(key: player.key).update_all(
        glicko_rating: player.obj.rating,
        glicko_deviation: player.obj.rating_deviation,
        glicko_volarity: player.obj.volatility
      )
    end

    puts 'done'
    true
  end

  def calc_per_1_game
    NbaTeam.initialize_rating

    NbaGameResult.order(:game_at).each do |nba_game_result|
      team_a = nba_game_result.team_a
      team_b = nba_game_result.team_b

      period = Glicko2::RatingPeriod.from_objs(
        "#{team_a.key}": team_a.rating,
        "#{team_b.key}": team_b.rating
      )

      # Register a game where rating1 wins against rating2
      # Note: In this Gem, less score is winner.
      period.game(
        [team_a.key, team_b.key],
        [-1 * nba_game_result.score_a, -1 * nba_game_result.score_b]
      )

      # Generate the next rating period with updated players
      next_period = period.generate_next(0.5)

      # Update all Glicko ratings
      next_period.players.each(&:update_obj)

      puts "#{team_a.key}(#{nba_game_result.score_a}) VS #{team_b.key}(#{nba_game_result.score_b})"
      puts "#{next_period.players[0].key}: #{next_period.players[0].obj.rating}"
      puts "#{next_period.players[1].key}: #{next_period.players[1].obj.rating}"

      # Output updated Glicko ratings
      next_period.players.each do |player|
        NbaTeam.where(key: player.key).update_all(
          glicko_rating: player.obj.rating,
          glicko_deviation: player.obj.rating_deviation,
          glicko_volarity: player.obj.volatility
        )
      end

      nba_game_result.apply_team_score
    end

    puts 'done'
    true
  end
end
