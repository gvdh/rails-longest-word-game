require 'open-uri'
require 'json'

class InterfaceController < ApplicationController

  def game
    @grid = generate_grid
    @start_time = Time.now
  end

  def score
    total_time = Time.now - params[:time].to_time
    @grid = params[:grid]
    @attempt = params[:answer]
    if validation_of_attempt(@attempt, @grid)
      @result = { time: total_time, score: ((10 - total_time) + @attempt.length), message: "Well done" }
    else
      @result = { time: total_time, score: 0, message: message(@attempt, @grid) }
    end
    @result
    end
  end

  def message(attempt, grid)
    dictionary = JSON.parse(open("https://wagon-dictionary.herokuapp.com/" + attempt).read)
    return "Empty" if attempt == ""
    return "not an english word" if dictionary["found"] == false
    attempt.upcase.chars.each do |letter|
      return "not in the grid" if attempt.count(letter) > @grid.count(letter) || !grid.include?(letter)
    end
  end

  private

  def generate_grid
    (0...9).map { (65 + rand(26)).chr }
  end

  def validation_of_attempt(attempt, grid)
    dictionary = JSON.parse(open("https://wagon-dictionary.herokuapp.com/" + attempt).read)
    return false if attempt == ""
    return false if dictionary["found"] == false
    attempt.upcase.chars.each do |letter|
      return false if attempt.count(letter) > @grid.count(letter)
      return false unless @grid.include?(letter)
    end

end
