namespace :scrape do
	desc "featured"
	task :featured => :environment do
		@attempts_f = 0
		begin
			FeaturedVideo.delete_all
			begin_count = FeaturedVideo.count
			puts "Table reset to: " + begin_count.to_s
			# Set an array of User Agents
			user_agents = ["Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:43.0) Gecko/20100101 Firefox/43.0",
					 		"Mozilla/5.0 (compatible; Konqueror/3; Linux)",				
					  		"Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.4) Gecko/20030624",
					  		"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:43.0) Gecko/20100101 Firefox/43.0",
					  		"Mozilla/5.0 (Macintosh; U; PPC Mac OS X Mach-O; en-US; rv:1.4a) Gecko/20030401",
					  		"Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_2; de-at) AppleWebKit/531.21.8 (KHTML, like Gecko) Version/4.0.4 Safari/531.21.10",
					  		"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_2) AppleWebKit/601.3.9 (KHTML, like Gecko) Version/9.0.2 Safari/601.3.9",
					  		"Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.125 Safari/537.36",
					 		"Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)",
					  		"Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; .NET CLR 1.1.4322; .NET CLR 2.0.50727)",
							"Mozilla/5.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; .NET CLR 1.1.4322; .NET CLR 2.0.50727)",
							"Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0)",
							"Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.2; WOW64; Trident/6.0)",
							"Mozilla/5.0 (Windows NT 6.3; WOW64; Trident/7.0; rv:11.0) like Gecko", 
							"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2486.0 Safari/537.36 Edge/13.10586",
							"Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.4b) Gecko/20030516 Mozilla Firebird/0.6",
							"Mozilla/5.0 (Windows NT 6.3; WOW64; rv:43.0) Gecko/20100101 Firefox/43.0",
							"Mozilla/5.0 (iPhone; CPU iPhone OS 9_1 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13B5110e Safari/601.1",
							"Mozilla/5.0 (iPad; CPU OS 9_1 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13B143 Safari/601.1",
							"Mozilla/5.0 (Linux; Android 5.1.1; Nexus 7 Build/LMY47V) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.76 Safari/537.36"]
			user_agent = user_agents.sample # Randomly select an agent

			#gostream = "https://gomovies.to/"
			# hdonline = "https://hdonline.to"
			kat = "http://kat.tv/cinema-movies.html"
			primewire = "http://www.primewire.ac"
			#watchepisodeseries = "http://www.watchepisodeseries.com"
			watchfree = "http://www.gowatchfreemovies.to"

			
			doc = Nokogiri::HTML(open(kat, 'User-Agent' => user_agent).read, nil, 'utf-8')
			entries = doc.css('.item')
			entries.each do |entry|	
				title = entry.css('a')[0]['onmouseover']
				title_2 = title.split('<b>').last.split('</b>').first.strip
				if !FeaturedVideo.exists?(title: title_2)
					FeaturedVideo.create(title: title_2)
				end			
			end
			puts "Completed kat..."
			doc_3 = Nokogiri::HTML(open(primewire, 'User-Agent' => user_agent).read, nil, 'utf-8')
			entries_3 = doc_3.css('featured_movie_item')
			entries_3.each do |entry|	
				title = entry.css('a')[0]['title']
				title_3 = title.split('Watch ').first.strip
				if !FeaturedVideo.exists?(title: title_3)
					FeaturedVideo.create(title: title_3)
				end			
			end
			puts "Completed primewire..."
			# doc_4 = Nokogiri::HTML(open(watchepisodeseries, 'User-Agent' => user_agent).read, nil, 'utf-8')
			# entries_4 = doc_4.css('.featured-ep-box')
			# entries_4.each do |entry|	
			# 	title = entry.css('.va a').text
			# 	title_4 = title.split(' Season').first.strip
			# 	if !FeaturedVideo.exists?(title: title_4)
			# 		FeaturedVideo.create(title: title_4)
			# 	end			
			# end
			# puts "Completed watchepisodeseries..."
			doc_5 = Nokogiri::HTML(open(watchfree, 'User-Agent' => user_agent).read, nil, 'utf-8')
			entries_5 = doc_5.css('.item')
			entries_5.each do |entry|	
				title = entry.css('a')[0]['title']
				title_5 = title.split('Watch Putlocker ').last.split('(').first.strip
				if !FeaturedVideo.exists?(title: title_5)
					FeaturedVideo.create(title: title_5)
				end			
			end
			puts "Completed #{watchfree}..."
			puts "Completed featured scrapes successfully.."
			end_count = FeaturedVideo.count
			puts "Table population: " + end_count.to_s
		rescue Exception => e
			@attempts_f += 1
			puts "featured scrape" + e.message.to_s
			if @attempts_f < 3
				puts "retrying.."
				sleep(2)
				retry
			else
				puts "Completed 3 attempts and failed. Exiting this task."
			end
		end
	end
end


