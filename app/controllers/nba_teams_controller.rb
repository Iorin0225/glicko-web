# frozen_string_literal: true

class NbaTeamsController < ApplicationController
  def index
    order_column = params[:order] ||= :glicko_rating
    @nba_teams = NbaTeam.order("#{order_column}": :desc)
  end
end
