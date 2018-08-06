require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @rand_letters = []
    10.times do
      @rand_letters << ('A'..'Z').to_a.sample
    end
  end

  def score

    computer_grid = params[:computer_grid].split(" ")
    player_grid = params[:guess]
    player_grid = player_grid.scan(/\w/).each { |letter| letter.upcase!}
    @validity = false
    if include?(computer_grid, player_grid) == true
      @word = params[:guess]
      @response = open("https://wagon-dictionary.herokuapp.com/#{@word}")
      json = JSON.parse(@response.read)
      if json["found"] == true
        @validity = true
        session[:user_score] += player_grid.length
      else
        @validity = false
      end
    end
  end

  private

  def include?(computer_grid, player_grid)
    if computer_grid.count >= player_grid.count
      player_grid.all? { |letter| computer_grid.include?(letter)}
    else
      false
    end
  end
end



