require 'task_helpers/application_helper'

namespace :scrape do
	desc "watchfree tv"
	task :watchfree_tv => :environment do
		@attempts_wftv = 0
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
			action = "#{site_url}/?genre=action&tv=&page="
			adventure = "#{site_url}/?genre=adventure&tv=&page="
			animation = "#{site_url}/?genre=animation&tv=&page="
			biography = "#{site_url}/?genre=biography&tv=&page="
			comedy = "#{site_url}/?genre=comedy&tv=&page="
			crime = "#{site_url}/?genre=crime&tv=&page="
			documentary = "#{site_url}/?genre=documentary&tv=&page="
			drama = "#{site_url}/?genre=drama&tv=&page="
			family = "#{site_url}/?genre=family&tv=&page="
			fantasy = "#{site_url}/?genre=fantasy&tv=&page="
			history = "#{site_url}/?genre=history&tv=&page="
			horror = "#{site_url}/?genre=horror&tv=&page="
			japanese = "#{site_url}/?genre=japanese&tv=&page="
			korean = "#{site_url}/?genre=korean&tv=&page="
			music = "#{site_url}/?genre=music&tv=&page="
			musical = "#{site_url}/?genre=musical&tv=&page="
			mystery = "#{site_url}/?genre=mystery&tv=&page="
			romance = "#{site_url}/?genre=romance&tv=&page="
			sci_fi = "#{site_url}/?genre=sci-fi&tv=&page="
			short = "#{site_url}/?genre=short&tv=&page="
			sport = "#{site_url}/?genre=sport&tv=&page="
			thriller = "#{site_url}/?genre=thriller&tv=&page="
			war = "#{site_url}/?genre=war&tv=&page="
			western = "#{site_url}/?genre=western&tv=&page="
			# Push each bsg url into categories array
			categories.push(action, adventure, drama, family, fantasy, horror, mystery, romance, sci_fi, thriller, western)
			#  history, biography, comedy, crime, documentary, action, animation, korean, music, musical, japanese, short, sport, war, western
			count = (1..200).to_a #200
			 
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
					    site = "#{site_url}"					   	

					    if link.is_valid_url?					   	 		         

						    doc = Nokogiri::HTML(open(link, 'User-Agent' => user_agent).read, nil, 'utf-8')

							entries = doc.css('.movie_data') 
							if entries
								test_node = entries.css('td')
								if test_node
									cast = entries.css('.movie_actors').search('a')
									if cast
										actors = entries.css('.movie_actors').search('a').map(&:text).join(', ').strip
									end
								end
								genres = entries.css('tr:nth-child(1)').search('a')
								if genres
									genres = entries.css('tr:nth-child(1)').search('a').map(&:text).join(', ').strip
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
					puts "Could not find #{site} tv base class for entries" 
				end
				puts "#{Time.now} - #{site} tv Sweep finished.."	
			end
		  	puts "#{Time.now} - #{site_url} tv Scrape Completed!" 
			puts "User Agent used: " + user_agent.to_s 
		rescue Exception => e
			@attempts_wftv += 1
			puts "gowatchfreemovies tv " + e.message.to_s
			if @attempts_wftv < 3
				puts "retrying.."
				sleep(2)
				retry
			else
				puts "Completed 3 attempts and failed. Exiting this task."
			end
		end 
	end
end # Yay we are done!