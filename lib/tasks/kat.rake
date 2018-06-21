require 'task_helpers/application_helper'

namespace :scrape do
	desc "kat movies"
	task :kat => :environment do

		@attempts_k = 0
		begin
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
			
			categories = []
			action = "http://kat.tv/movies-genres/action/page-"
			adventure = "http://kat.tv/movies-genres/adventure/page-"
			animation = "http://kat.tv/movies-genres/animation/page-"
			anime = "http://kat.tv/movies-genres/anime/page-"
			biography = "http://kat.tv/movies-genres/biography/page-"
			comedy = "http://kat.tv/movies-genres/comedy/page-"
			crime = "http://kat.tv/movies-genres/crime/page-"
			drama = "http://kat.tv/movies-genres/drama/page-"
			family = "http://kat.tv/movies-genres/family/page-"
			fantasy = "http://kat.tv/movies-genres/fantasy/page-"
			historical = "http://kat.tv/movies-genres/historical/page-"
			horror = "http://kat.tv/movies-genres/horror/page-"
			kungfu = "http://kat.tv/movies-genres/kung-fu/page-"
			musical = "http://kat.tv/movies-genres/musical/page-"
			music = "http://kat.tv/movies-genres/music/page-"
			mystery = "http://kat.tv/movies-genres/mystery/page-"
			romance = "http://kat.tv/movies-genres/romance/page-"
			sci_fi = "http://kat.tv/movies-genres/sci-fi/page-"
			sport = "http://kat.tv/movies-genres/sport/page-"
			thriller = "http://kat.tv/movies-genres/thriller/page-"
			western = "http://kat.tv/movies-genres/western/page-"
			war = "http://kat.tv/movies-genres/war/page-"
			
			categories.push(action, adventure, animation, anime, biography, comedy, crime, drama, family, fantasy, historical, horror, kungfu, musical, music, mystery, romance, sci_fi, thriller)
			# action, comedy, drama, horror, romance, sci_fi, thriller
			# action, adventure, animation, anime, biography, comedy, crime, drama, family, fantasy, historical, horror, kungfu, musical, music, mystery, romance, sci_fi, thriller
			#  , western, war, sport,
			count = (1..2).to_a # 450 max comedy
			
			url_array = []                 			
			categories.each do |cat|	   			
				count.select do |num|      			
					url = cat + num.to_s + ".html"  
					url_array.push(url)    			
				end	
			end
			
			url_array.each do |crawl|
				puts "Crawling: " + crawl.to_s 

			    doc = Nokogiri::HTML(open(crawl, 'User-Agent' => user_agent).read, nil, 'utf-8') 

				entries = doc.css('.item') 
				if entries 
					entries.each do |entry| 
					        
					    title = entry.css('a')[0]['onmouseover']
						title = title.split('<b>').last.split('</b>').first    	 			  
						link = entry.css('a')[0]['href']      		 		          		  
						img = entry.css('img')[0]['src']   		          					  
						cat = crawl.split('movies-genres/').last.split('/').first.capitalize  
						cat == "Kung-fu" ? cat = 'Kungfu' : cat = cat                     	  
						site = "kat.tv"

						if link.is_valid_url? # required from our task_helpers

							doc = Nokogiri::HTML(open(link, 'User-Agent' => user_agent).read, nil, 'utf-8') 
							puts "Secondary crawl: " + link.to_s
							entries = doc.css('.box_info') 
							if entries 
								test_1 = entries.css('.value:nth-child(6)').text.strip[0..-2] 
								if test_1 != '' 
									actors = entries.css('.value:nth-child(6)').text.strip[0..-2] 
								 	actors =~ /|/ ? actors = actors.split(' | ').join(', ') : actors = actors
								 	actors =~ /;/ ? actors = actors.split(' ; ').join(', ') : actors = actors
								 	actors =~ /\s{1}\W\s{1}/ ? actors = actors.split(' / ').join(', ') : actors = actors	
								end
								test_2 = entries.css('.value:nth-child(10)').text.strip[0..-2]           
								if test_2 != ''	        
									genres = entries.css('.value:nth-child(10)').text.strip[0..-2]
									genres =~ /|/ ? genres = genres.split(' | ').join(', ') : genres = genres
									genres =~ /;/ ? genres = genres.split(' ; ').join(', ') : genres = genres
									genres =~ /\s{1}\W\s{1}/ ? genres = genres.split(' / ').join(', ') : genres = genres
								end
								if actors && genres 
									tags = actors + ', ' + genres 
								elsif !actors && genres
									tags = genres	
								elsif actors && !genres
									tags = actors
								elsif !actors && !genres
									tags = "not available"
								end	
							else
								bad_url = "Could not find base class for tags on this video, bad url: " + link.to_s
								tags = "not available"
								puts bad_url 
							end
						else
							bad_url = "Skipping tags sector, bad url: " + link.to_s
							tags = "not available"
							puts bad_url
						end

						title = title.valid_format
						link = link.valid_format
						img = img.valid_format
						tags = tags.valid_format

						tags =~ /\s{2,}/ ? tags = tags.gsub(/\s{2,}/, '') : tags = tags
						tags =~ /^,\s/ ? tags = tags.sub(/^,\s/, '') : tags = tags

						if Video.exists?(title: title, site: site)
							puts "#{title} already exists from #{site}"
						else
					        Video.create(								 
					            title: title,							 
					            link: link,						 
					            img: img,                                
					            category: cat,                            
					            site: site,                      
					            tag_list: tags
					        )
					    end
					end
				else
					puts "Could not find base class for entries" 
				end
				puts "#{Time.now} - kat Sweep finished.."	  	
		  	end
		  	puts "#{Time.now} - kat Scrape Completed!" 
			puts "User Agent used: " + user_agent.to_s 
		rescue Exception => e
			@attempts_k += 1
			puts "kat " + e.message.to_s
			if @attempts_k < 3
				puts "retrying.."
				sleep(2)
				retry
			else
				puts "Completed 3 attempts and failed. Exiting this task."
			end
		end
	end
end