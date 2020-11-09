# comment
class GamesController < ApplicationController
  def new
    @random_letters = ('A'..'Z').to_a.sample(9)
  end

  def home
  end

  def score
    @answer = nil
    @score = 0
    attempt = params[:word].split('')
    grid = params[:grid].split
    url = "https://wagon-dictionary.herokuapp.com/#{attempt.join}"
    if parse(url) && compare(attempt, grid)
      @answer = "Congratulations #{attempt.join.upcase} is a valid English word"
      @score = attempt.count**2
      if session[:score]
        session[:score] += @score
      else
        session[:score] = @score
      end
    elsif parse(url) == false && compare(attempt, grid) == true
      @answer = "Sorry but #{attempt.join.upcase} does not seem to be an English word"
    elsif compare(attempt, grid) == false
      @answer = "Sorry but #{attempt.join.upcase} cant be built out of #{grid.join}"
    end
  end

  # this method to parse the url and get the value of found key
  def parse(url)
    reply_serialized = open(url).read
    reply = JSON.parse(reply_serialized)
    reply['found']
  end

  # this method returns a boolen, matching the grid or not
  def compare(attempt, grid)
    result = attempt.map do |letter|
      grid.include?(letter.upcase)
    end
    result.all? { |x| x == true }
  end
end
