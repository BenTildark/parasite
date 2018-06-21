module ApplicationHelper
  	
	String.class_eval do # call methods defined within on any string object

		def is_valid_url? # check for a valid url variable
			uri = URI.parse self
			uri.kind_of? URI::HTTP
		rescue URI::InvalidURIError
			false
		end

		def valid_format # check strings & remove invaild/undef characters
			encoding_options = {
				:invalid           => :replace,  
				:undef             => :replace,  
				:replace           => '',        
				:universal_newline => true       
			}
		 	encode(Encoding.find('ASCII'), encoding_options)
		end

		def pluralize_without_count(count, noun, text = nil)
		  if count != 0
		    count == 1 ? "an #{noun}#{text}" : "#{noun.pluralize}#{text}"
		  end
		end
	end	
end

