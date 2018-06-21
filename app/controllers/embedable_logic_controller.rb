class EmbedableLogicController < ApplicationController

	def embed_player # kat.tv
		puts "running embed player"
		begin
			Timeout.timeout(29) do
				begin
					url = params[:embed_url]
					@driver = Watir::Browser.new :phantomjs#, driver_path: '/Users/Michaels/.phantomjs/2.1.1/darwin/bin/phantomjs'
					@driver.goto(url)
					doc = Nokogiri::HTML(@driver.html)
					@embed_url = doc.css('.player iframe')[0]['src']
				rescue Exception => e
					@method_error = "Embed player ran error: " + e.message.to_s
				end
			end
		rescue Timeout::Error
			@time_out = "Video embed request timed out. Try refresh page & try soon."
		ensure
			if !@driver.nil?
				@driver.close
			end
		end
	end

	def wf2_embed_player
		puts "running wf2 embed player"
		begin
			Timeout.timeout(29) do
				begin
					url = params[:wf2_embed_url]
					@driver = Watir::Browser.new :phantomjs, driver_path: '/usr/local/bin/phantomjs'
					@driver.goto(url)
					doc = Nokogiri::HTML(@driver.html)
					#puts doc.to_html
					video_player = doc.at_css('.video_player')
					if video_player
						@embed_url = video_player.css('iframe')[0]['src']
					end
					tv_episodes = doc.css('.tv_container')
					if tv_episodes
						puts "tv episode exists"
						domain = "http://www.gowatchfreemovies.to"
						@episode_urls = []
						tv_episode_item = tv_episodes.search('.tv_episode_item').each do |row|
							cell = row.search('a').map { |cell| domain + cell['href'] }
							@episode_urls.push(cell.first)
						end
					end
				rescue Exception => e
					@method_error = "Wf2 embed player ran error: " + e.message.to_s
				end
			end
		rescue Timeout::Error
			@time_out = "Video embed request timed out. Try refresh page & try soon."
		ensure
			if !@driver.nil?
				@driver.close
			end
		end
	end

	def embed_episode #for wf2 season episode embed
		puts "running embed episode"
		begin
			url = params[:embed_episode]
			@driver = Watir::Browser.new :phantomjs#, driver_path: '/Users/Michaels/.phantomjs/2.1.1/darwin/bin/phantomjs'
			@driver.goto(url)
			doc = Nokogiri::HTML(@driver.html)
			video_player = doc.at_css('.video_player')
			if video_player
				@embed_url = video_player.css('iframe')[0]['src']
			else
				@nil_player = "Player not found"
			end
		rescue Exception => e
			@method_error = "Wf2 embed episode ran error: " + e.message.to_s
		ensure
			if !@driver.nil?
				@driver.close
			end
		end
	end

	def follow_links # primewire
		puts "running follow links"
		begin
			Timeout.timeout(29) do
				begin
					domain = "https://www.primewire.ac"
					url = params[:follow_link]
					puts "Url: " + url
					@driver = Watir::Browser.new :phantomjs#, driver_path: '/Users/Michaels/.phantomjs/2.1.1/darwin/bin/phantomjs'
					doc = Nokogiri::HTML(open(url))

					links = doc.search('.movie_version_link a').count
					@count = links -2
					puts "Crude links count: " + @count.to_s

					range = (3..6).to_a

					url_paths = []
					range.each do |x|
						up = doc.css('.movie_version_link a')[x]['href']
						url_paths.push(up)
					end

					trackable_urls = []
					url_paths.each do |up|
						tu = domain + up
						trackable_urls.push(tu)
					end

					links = []
					trackable_urls.each do |track|
						@driver.goto(track)
						driver_url = @driver.url
						puts driver_url
						links.push(driver_url)
					end

					links.delete_if { |x| x[/lng=EN/] } # filter out the bad links(sign-ups etc)

					@links = links

					puts "Refined links count: " + links.count.to_s
					puts "Completed task"
				rescue Exception => e
					@error = e.message.to_s
				end
			end
		rescue Timeout::Error
			@timeout = "Video embed request timed out. Refresh page & try again soon."
		ensure
			if !@driver.nil?
				@driver.close
			end
		end
	end

	def embed_prime_openload
		puts "running embed prime openload"
		raw_urls = params[:prime_openload]
		@embed_urls = raw_urls.gsub('openload.co/f', 'openload.co/embed').split(',').map{ |x| x[0, 38] }
	end

	def prime_openload_player
		@embed_url = params[:prime_openload_url]
	end
end