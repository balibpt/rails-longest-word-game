require 'open-uri'
require 'JSON'

class GamesController < ApplicationController
  def new
    alphabets = ('A'..'Z').to_a
    @letters = []
    10.times do
      @letters << alphabets.sample
    end
    session[:score] ||= 0
  end

  def score
    @answer = params[:answer]
    @letters = params[:letters]
    @result = @answer.present? && params[:letters].split(' ').permutation(@answer.length).to_a.include?(@answer.upcase.chars)
    if @result
      url = "https://wagon-dictionary.herokuapp.com/#{@answer}"
      response = URI.open(url).read
      data = JSON.parse(response)
      session[:score] += 1 if data['found'] == true
      @is_word = data['found']
    else
      @is_possible = false
    end
  end
end
