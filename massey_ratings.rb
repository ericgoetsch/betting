require 'pry'
require 'httparty'
require 'mechanize'
require 'Nokogiri'
require 'open-uri'
require 'watir'

browser = Watir::Browser.new
browser.goto 'masseyratings.com/pred.php?s=cf&sub=11604'
browser.button(id: 'showVegas').click
doc = Nokogiri::HTML(browser.html)

# # team name number one
# doc.css('.bodyrow').first.children.css('.fteam').first.css('a').first.children.text
# # line for team number one
# pry(main)> doc.css('.bodyrow').first.children.css('.fscore')[1].children.first.text

# #line for team number two
# pry(main)> doc.css('.bodyrow').first.children.css('.fscore')[1].children.last.text

# #team name number two
# doc.css('.bodyrow').first.children.css('.fteam').first.css('a').last.children.text

# # masseys line
# doc.css('.bodyrow').first.children.css('.fscore').css('.ltred').text

# # book line
# pry(main)> doc.css('.bodyrow').first.children.css('.fscore').css('.ltgreen').text


# # book over/under line
# doc.css('.bodyrow').first.children.css('.fscore').last.children.first.text

# # massey over/under line
# doc.css('.bodyrow').first.children.css('.fscore').last.children.last.text


rows = doc.css('.bodyrow')

rows.each do |row|
  team1 = row.css('.fteam').first.css('a').first.children.text
  team2 = row.css('.fteam').first.css('a').last.children.text
  team1_line = row.css('.fscore')[1].children.first.text
  team2_line = row.css('.fscore')[1].children.last.text

  puts "#{team1} Line: #{team1_line}"
  puts "#{team2} Line: #{team2_line}"

end
