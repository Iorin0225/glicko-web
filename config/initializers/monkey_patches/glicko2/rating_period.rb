# frozen_string_literal: true

module Glicko2
  # Glicko ratings are calculated in bulk at the end of arbitrary, but fixed
  # length, periods named rating periods. Where a period is fixed to be long
  # enough that the average number of games that each player has played in is
  # about 5 to 10 games. It could be weekly, monthly or more as required.
  class RatingPeriod
    attr_reader :players

    # @param [Array<Player>] players
    def initialize(players)
      @players = players
      @cache = players.each_with_object({}) do |player, memo|
        raise DuplicatePlayerError unless memo[player.key].nil?

        memo[player.key] = player
        memo
      end
      @raters = players.each_with_object({}) do |player, memo|
        memo[player.key] = Rater.new(player.rating)
        memo
      end
    end

    # Create rating period from list of seed objects
    #
    # @param [Array<#rating,#rating_deviation,#volatility>] objs seed value objects
    # @return [RatingPeriod]
    def self.from_objs(objs)
      new(objs.map { |key, obj| Player.from_obj(key, obj) })
    end

    # Register a game with this rating period
    #
    # @param [Array<#rating,#rating_deviation,#volatility>] game_seeds ratings participating in a game
    # @param [Array<Integer>] ranks corresponding ranks
    def game(game_seeds, ranks)
      game_seeds.each_with_index do |iseed, i|
        game_seeds.each_with_index do |jseed, j|
          next if i == j

          @raters[iseed.to_sym].add(player(jseed.to_sym).rating, Util.ranks_to_score(ranks[i], ranks[j]))
        end
      end
    end

    # Generate a new {RatingPeriod} with a new list of updated {Player}
    #
    # @return [RatingPeriod]
    def generate_next(tau)
      p = []
      @players.each do |player|
        p << Player.new(player.key.to_sym, @raters[player.key.to_sym].rate(tau), player.obj)
      end
      self.class.new(p)
    end

    # Fetch the player associated with a seed object
    #
    # @param [#rating,#rating_deviation,#volatility] obj seed object
    # @return [Player]
    def player(key)
      @cache[key]
    end

    def to_s
      "#<RatingPeriod players=#{@players}"
    end
  end
end
