require 'task_helpers/application_helper'

namespace :scrape do
	desc "primewire"
	task :primewire => :environment do
		@attempts_p = 0
		begin
		    
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
			
			categories = []
			action = "https://www.primewire.ac/?genre=Action&page="
			adventure = "https://www.primewire.ac/?genre=Adventure&page="
			animation = "https://www.primewire.ac/?genre=Animation&page="
			biography = "https://www.primewire.ac/?genre=Biography&page="
			comedy = "https://www.primewire.ac/?genre=Comedy&page="
			crime = "https://www.primewire.ac/?genre=Crime&page="
			documentary = "https://www.primewire.ac/?genre=Documentary&page="
			drama = "https://www.primewire.ac/?genre=Drama&page="
			family = "https://www.primewire.ac/?genre=Family&page="
			fantasy = "https://www.primewire.ac/?genre=Fantasy&page="
			game_show = "https://www.primewire.ac/?genre=Game-Show&page="
			history = "https://www.primewire.ac/?genre=History&page="
			horror = "https://www.primewire.ac/?genre=Horror&page="
			japanese = "https://www.primewire.ac/?genre=Japanese&page="
			korean = "https://www.primewire.ac/?genre=Korean&page="
			music = "https://www.primewire.ac/?genre=Music&page="
			musical = "https://www.primewire.ac/?genre=Musical&page="
			mystery = "https://www.primewire.ac/?genre=Mystery&page="
			reality_tv = "https://www.primewire.ac/?genre=Reality-TV&page="
			romance = "https://www.primewire.ac/?genre=Romance&page="
			sci_fi = "https://www.primewire.ac/?genre=Sci-Fi&page="
			short = "https://www.primewire.ac/?genre=Short&page="
			sport = "https://www.primewire.ac/?genre=Sport&page="
			talk_show = "https://www.primewire.ac/?genre=Talk-Show&page="
			thriller = "https://www.primewire.ac/?genre=Thriller&page="
			war = "https://www.primewire.ac/?genre=War&page="
			western = "https://www.primewire.ac/?genre=Western&page="
			zombies = "https://www.primewire.ac/?genre=Zombies&page="
			
			categories.push(action, adventure, biography, family, fantasy, history, horror, mystery, romance, sci_fi, thriller, zombies)
			# action, comedy, drama, horror, romance, sci_fi, thriller, western, zombies
			# action, adventure, animation, biography, fantasy, game_show, history, horror, japanese, korean, music, musical, mystery, reality_tv, romance, sci_fi, short, sport, talk_show, thriller, war, western, zombies, 
			# comedy, crime, documentary, drama, family   
			count = (1..400).to_a #Action max page count #400
			 
			url_array = []                 
			categories.each do |cat|	   
				count.select do |num|      
					url = cat + num.to_s   
					url_array.push(url)    
				end	
			end
			
			@try = 0
			url_array.each do |crawl|
				begin
					puts "Crawling: " + crawl.to_s
					
				    doc = Nokogiri::HTML(open(crawl, 'User-Agent' => user_agent).read, nil, 'utf-8')

					entries = doc.css('.index_item_ie') 
					if entries 
						entries.each do |entry|

							title = entry.css('a')[0]['title'].strip
							link_url = entry.css('a')[0]['href']			 		         
							link = "https://www.primewire.ac/" << link_url
							img_url = entry.css('img')[0]['src'] 							 		         
							img = "https://www.primewire.ac" << img_url
							category = crawl.split('genre=').last.split('&').first.capitalize
							tags = entry.search('.item_categories a').map(&:text).join(', ').strip
							site = "primewire.ac"

							# if link.is_valid_url?

							# 	doc = Nokogiri::HTML(open(link, 'User-Agent' => user_agent).read, nil, 'utf-8')
							# 	puts "Secondary crawl: " + link.to_s
							# 	entries = doc.css('.movie_info')
							# 	if entries
							# 		if entries.at_css('.movie_info_actors a')
							# 			actors = entries.search('.movie_info_actors a').map(&:text).join(', ').strip	
							# 		end
									
							# 		if actors && genres
							# 			tags = actors + ', ' + genres
							# 		elsif !actors && genres
							# 			tags = genres
							# 		elsif actors && !genres
							# 			tags = actors
							# 		elsif !actors && !genres
							# 			tags = "not available"
							# 		end	
							# 	else
							# 		bad_url = "Could not find class for tags cast on this video, bad url: " + link.to_s
							# 		tags = genres
							# 		puts bad_url 
							# 	end
							# else
							# 	bad_url = "Skipping tags sector, bad url: " + link.to_s
							# 	tags = genres
							# 	puts bad_url
							# end

							title = title.valid_format
							link = link.valid_format
							img = img.valid_format
							tags = tags.valid_format
							
							tags =~ /\s{2}/ ? tags = tags.gsub(/\s{2}/, ' ') : tags = tags
							tags =~ /\s{1,}\W\s{1,}/ ? tags = tags.gsub(/\s{1,}\W\s{1,}/, ', ') : tags = tags
							tags =~ /^,\s/ ? tags = tags.sub(/^,\s/, '') : tags = tags

							# puts title
							# puts link
							# puts img
							# puts category
							# puts site
							# puts tags

							if Video.exists?(title: title, site: site)
								puts "#{title} already exists from #{site}"
							else  
								Video.create(							 
								    title: title,
								    category: category,						 
								    link: link,							 
								    img: img,                                                
								    site: site,
								    tag_list: tags
								)
							end
							# sleep(5)
						end
					else
						puts "Could not find class for entries"
					end
				rescue Exception => e
					@try += 1
					puts "primewire e:1 " + e.message.to_s
					if @try < 10
						retry
					else
						puts "Tried 10 times, exiting this request cycle"
					end
				end
				puts "#{Time.now} - Primewire sweep finished.."	
			end
		  	puts "#{Time.now} - Primewire task completed!" 
			puts "Last user agent used: " + user_agent.to_s 
		rescue Exception => e
			@attempts_p += 1
			puts "primewire e:2 " + e.message.to_s
			if @attempts_p < 3
				puts "retrying.."
				sleep(2)
				retry
			else
				puts "Completed 3 attempts and failed. Exiting this task."
			end
		end 
	end
end # Yay we are done!





