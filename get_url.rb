require 'pry'
require 'httparty'
require 'mechanize'
require 'nokogiri'
require 'open-uri'

def get_url
  puts "Would you like NFL or NCAA picks?"
  puts "Choose"
  puts "1. NFL"
  puts "2. NCAA"

  answer = gets.chomp.to_i

  if answer == 1
    url = 'http://www.masseyratings.com/pred.php?s=nfl'
  else
    url = 'http://www.masseyratings.com/pred.php?s=cf&sub=11604'
  end
end
