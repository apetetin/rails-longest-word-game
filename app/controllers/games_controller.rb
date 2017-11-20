require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    alphabet = ("A".."Z").to_a
    @grid = []
    10.times do
      letter = alphabet.sample
      @grid << letter
      alphabet.delete(letter)
    end
    @grid
  end

  def score
    word = params[:word].split("")
    new_word = word.map { |letter| letter.upcase }
    grid = params[:grid]
    if  new_word.length > grid.length
      status = "too long"
    else
      new_word.each do |letter|
        if !grid.include?(letter)
          status = "not in the grid"
        else
          grid = grid.delete(letter)
        end
      end
      if status != "not in the grid"
        url = open("https://wagon-dictionary.herokuapp.com/#{new_word.join("")}").read
        result = JSON.parse(url)
        if result["found"] == false
          status = "not an english word"
        else
          status = "#{result["length"]}"
        end
      end
    end
    @message = compute_msg(status)
  end

  private

  def compute_msg(status)
    if status == "too long"
      return "The word is too long"
    elsif status == "not in the grid"
      return "Some letters are not in the grid"
    elsif status == "not an english word"
      return "This is not an english word"
    else
      return "Well done. Your score is #{status}"
    end
  end

end

