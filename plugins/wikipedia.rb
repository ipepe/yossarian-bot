#  -*- coding: utf-8 -*-
#  wikipedia.rb
#  Author: slackR (slackErEhth77) and William Woodruff
#  ------------------------
#  A Cinch plugin to get info from Wikipedia for yossarian-bot.
#  ------------------------
#  This code is licensed by slackErEhth77 under the MIT License.
#  http://opensource.org/licenses/MIT

require 'json'
require 'open-uri'

require_relative 'yossarian_plugin'

class Wikipedia < YossarianPlugin
	include Cinch::Plugin

	def usage
		'!wiki <search> - Search Wikipedia for the given <search>.'
	end

	def match?(cmd)
		cmd =~ /^(!)?wiki$/
	end

	match /wiki (.+)/, method: :search_wiki

	def search_wiki(m, search)
		query = URI.encode(search)
		url = "https://en.wikipedia.org/w/api.php?action=opensearch&format=json&search=#{query}"

		begin
			results = JSON.parse(open(url).read)
			unless results[1].empty?
				if results[2][0].empty?
					content = "No extract provided."
				else
					content = results[2][0]
				end
				link = results[3][0].sub('https://en.wikipedia.org/wiki/', 'http://enwp.org/')

				m.reply "#{link} - #{content}", true
			else
				m.reply "No results for #{search}.", true
			end
		rescue Exception => e
			m.reply e.to_s, true
		end
	end
end