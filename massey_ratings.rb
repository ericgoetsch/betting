require 'pry'
require 'httparty'
require 'mechanize'
require 'nokogiri'
require 'open-uri'
require 'watir'
require './get_url.rb'

puts "Please enter the url from masseyratings.com and hit enter"
url = get_url
puts "Please set the point differential between massey ratings and vegas lines that you would like to view"
pd = gets.chomp.to_i

browser = Watir::Browser.new
browser.goto url
browser.button(id: 'showVegas').click
doc = Nokogiri::HTML(browser.html)
browser.close

data = []

rows = doc.css('.bodyrow')

rows.each do |row|

  team_name_1       = row.css('.fteam').first.css('a').first.children.text
  team_name_2       = row.css('.fteam').first.css('a').last.children.text
  team_1_line       = row.css('.fscore')[1].children.first.text.to_f
  team_2_line       = row.css('.fscore')[1].children.last.text.to_f
  massey_line       = row.css('.fscore').css('.ltred').text.to_f
  vegas_line        = row.css('.fscore').css('.ltgreen').text.to_f
  vegas_over_under  = row.css('.fscore').last.children.first.text.to_f
  massey_over_under = row.css('.fscore').last.children.last.text.to_f
  if team_1_line >= 0

    if team_1_line.between?(vegas_line - 0.1, vegas_line +  0.1)
      team_1_vegas_line = vegas_line
      team_2_vegas_line = vegas_line * -1
    else
      team_1_vegas_line = vegas_line * -1
      team_2_vegas_line = vegas_line
    end

    if team_1_line.between?(massey_line - 0.1, massey_line + 0.1)
      team_1_massey_line = massey_line
      team_2_massey_line = -massey_line
    else
      team_1_massey_line = -massey_line
      team_2_massey_line = massey_line
    end
  else

    if team_1_line.between?(vegas_line + 0.1, vegas_line -  0.1)
      team_1_vegas_line = vegas_line
      team_2_vegas_line = vegas_line * -1
    else
      team_2_vegas_line = vegas_line
      team_1_vegas_line = vegas_line * -1
    end

    if team_1_line.between?(massey_line + 0.1, massey_line - 0.1)
        team_1_massey_line = massey_line
        team_2_massey_line = -massey_line
    else
        team_1_massey_line = -massey_line
        team_2_massey_line = massey_line
    end
  end

   team_data = {
    team_name_1: team_name_1,
    team_name_2: team_name_2,
    team_1_vegas_line: team_1_vegas_line,
    team_2_vegas_line: team_2_vegas_line,
    team_1_massey_line: team_1_massey_line,
    team_2_massey_line: team_2_massey_line,
    vegas_over_under: vegas_over_under,
    massey_over_under: massey_over_under
  }
  data << team_data unless team_data.values.include?(0.0)

end



data.each do |data|
 team_1_vegas_line    = data[:team_1_vegas_line]
 team_2_vegas_line    = data[:team_2_vegas_line]
 team_1_massey_line  = data[:team_1_massey_line]
 team_2_massey_line  = data[:team_2_massey_line]
 team_1              = data[:team_name_1]
 team_2              = data[:team_name_2]
 vegas_over_under    = data[:vegas_over_under]
 massey_over_under   = data[:massey_over_under]


  if (team_1_vegas_line.abs - team_1_massey_line.abs) >= pd
    puts "Game Line: #{team_1} VS. #{team_2} #{team_1_vegas_line.abs - team_1_massey_line.abs}"
  end

  if (vegas_over_under - massey_over_under).abs >= pd
    puts "Over/Under: #{team_1} VS. #{team_2} #{vegas_over_under - massey_over_under}"
  end

end
