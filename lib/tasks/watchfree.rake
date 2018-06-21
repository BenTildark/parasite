require 'task_helpers/application_helper'

namespace :scrape do
	desc "watchfree"
	task :watchfree => :environment do
		@attempts_wf = 0
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
			# Defined an empty array & base-scrape-genre (bsg) Url strings
			site_url = "http://www.gowatchfreemovies.to"
			categories = []
			action = "#{site_url}/?genre=action&page="
			adventure = "#{site_url}/?genre=adventure&page="
			animation = "#{site_url}/?genre=animation&page="
			biography = "#{site_url}/?genre=biography&page="
			comedy = "#{site_url}/?genre=comedy&page="
			crime = "#{site_url}/?genre=crime&page="
			documentary = "#{site_url}/?genre=documentary&page="
			drama = "#{site_url}/?genre=drama&page="
			family = "#{site_url}/?genre=family&page="
			fantasy = "#{site_url}/?genre=fantasy&page="
			history = "#{site_url}/?genre=history&page="
			horror = "#{site_url}/?genre=horror&page="
			japanese = "#{site_url}/?genre=japanese&page="
			korean = "#{site_url}/?genre=korean&page="
			music = "#{site_url}/?genre=music&page="
			musical = "#{site_url}/?genre=musical&page="
			mystery = "#{site_url}/?genre=mystery&page="
			romance = "#{site_url}/?genre=romance&page="
			sci_fi = "#{site_url}/?genre=sci-fi&page="
			short = "#{site_url}/?genre=short&page="
			sport = "#{site_url}/?genre=sport&page="
			thriller = "#{site_url}/?genre=thriller&page="
			war = "#{site_url}/?genre=war&page="
			western = "#{site_url}/?genre=western&page="
			# Push each bsg url into categories array
			categories.push(action, adventure, comedy, crime, drama, documentary, family, fantasy, horror, romance, sci_fi, thriller)
			# action, comedy, drama, family, horror, romance, sci_fi, thriller
			# crime, adventure, music, musical, mystery, romance, family, sci_fi, short, # sport, thriller(only have up to thriller), war, western, fantasy, history, horror, japanese, korean, documentary, biography, animation 
			count = (2..1100).to_a # 1100 Drama
			
			url_array = []                 
			categories.each do |cat|	   
				count.select do |num|      
					url = cat + num.to_s   
					url_array.push(url)    
				end	
			end
			
			url_array.each do |crawl|
				puts "Crawling: " + crawl.to_s 

			    doc = Nokogiri::HTML(open(crawl, 'User-Agent' => user_agent).read, nil, 'utf-8') 
			    
				entries = doc.css('.item') 
				if entries   
					entries.each do |entry| 
					        
					    title = entry.css('a')[0]['title']
					    title = title.split('Putlocker ').last.split('(').first.strip  		 				 
					    link_url = entry.css('a')[0]['href']         		         
					    domain = "#{site_url}"			 		         
					    link = domain << link_url      		 			 	         
					    img_url = entry.css('img')[0]['src']	     		         
					    protocol = "http:" 							 		         
					    img = protocol << img_url            		 		         
					    category = crawl.split('genre=').last.split('&').first.capitalize 
					    site = "gowatchfreemovies.to"

					    if link.is_valid_url?		   	 		         
					    	
						    doc = Nokogiri::HTML(open(link, 'User-Agent' => user_agent).read, nil, 'utf-8')
						    puts "Secondary crawl: " + link.to_s
							entries = doc.css('.movie_data') 
							if entries
								test_node = entries.css('td')
								if test_node
									cast = entries.css('.movie_actors').search('a')
									if cast
										actors = entries.css('.movie_actors').search('a').map(&:text).join(', ').strip
									end
								end
								test_node = entries.css('tr')
								if test_node
									genres = entries.css('tr:nth-child(1)').search('a')
									if genres
										genres = entries.css('tr:nth-child(1)').search('a').map(&:text).join(', ').strip
									end        
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

						tags =~ /^,\s/ ? tags = tags.sub(/^,\s/, '') : tags = tags

					    if Video.exists?(title: title, site: site)
					    	puts "#{title} already exists from #{site}"
					    else  
					        Video.create(							 
					            title: title,						 
					            link: link,							 
					            img: img,                            
					            category: category,                     
					            site: site,
					            tag_list: tags
					        )
					    end    
					end
				else
					puts "Could not find #{site} base class for entries" 
				end
				puts "#{Time.now} - #{site} Sweep finished.."	 
			end
		  	puts "#{Time.now} - #{site_url} Scrape Completed!" 
			puts "User Agent used: " + user_agent.to_s 
		rescue Exception => e
			@attempts_wf += 1
			puts "gowatchfreemovies " + e.message.to_s
			if @attempts_wf < 8
				puts "retrying.."
				sleep(2)
				retry
			else
				puts "Completed 2 attempts and failed. Exiting this task."
			end
		end 
	end
end # Yay we are done!