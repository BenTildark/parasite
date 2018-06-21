class ApplicationController < ActionController::Base
  	protect_from_forgery with: :exception
  	before_action :genre_list
  	before_action :site_list
  	
  	private
  
  	def logged_in?
    	@current_user ||= User.find(session[:user_id]) if session[:user_id]
  	end
  	helper_method :logged_in?

    def force_http
        if request.ssl? && Rails.env.production?
            redirect_to root_url protocol: 'http://'
        end
    end
    helper_method :force_http

    def suggestions
        equal = @video.category
        @suggestions = Video.where(category: equal).where.not(id: @video).order("RANDOM()").limit(5)
    end
    helper_method :suggestions

    def tmdb
        search = Tmdb::Search.new 
        if @video.title =~ /- Season/
            alt_query = @video.title.split(' -').first
            search.resource('tv')
            search.query(alt_query)
        elsif @video.category == "Tv-series" || @video.category == "Reality-tv" || @video.category == "Talk-show" 
            search.resource('tv')
            search.query(@video.title)
        elsif @video.link =~ /season/ || @video.link =~ /tv-show/
            search.resource('tv')
            search.query(@video.title)
        else
            search.resource('movie')
            search.query(@video.title)    
        end
        search_response = search.fetch
        if search_response.present?
            i = 0
            if search_response[i].key?('release_date')
                release_date = search_response[i].fetch('release_date')
                @year_m = release_date[0..3]
            elsif search_response[i].key?('first_air_date')
                air_date = search_response[i].fetch('first_air_date')
                @year_t = air_date[0..3]
            end
            @description = search_response[i].fetch('overview')
            @rating = search_response[i].fetch('vote_average')

            video_id = search_response[i].fetch('id')

            if @video.title =~ /- Season/
                cast = Tmdb::TV.cast(video_id)
            else
                if @video.category == "Tv-series"
                cast = Tmdb::TV.cast(video_id)
                else
                detail_response = Tmdb::Movie.detail(video_id)
                cast = Tmdb::Movie.casts(video_id)
                end
            end
            if detail_response.present?
                if detail_response.key?('runtime')
                    @run_time = detail_response.fetch('runtime')
                end
            end
            if cast.present?
                @lead_char_name = cast[0].fetch('character')
                @lead_actor_name = cast[0].fetch('name')
                pro_img_path = cast[0].fetch('profile_path')
                domain_ext = "https://image.tmdb.org/t/p/w132_and_h132_bestv2"
                @lead_act_img_url = domain_ext << pro_img_path.to_s
            end
        end 
    end
    helper_method :tmdb

    def tmdb_poster_show
        search = Tmdb::Search.new 
        if @video.title =~ /- Season/
            alt_query = @video.title.split(' -').first
            search.resource('tv')
            search.query(alt_query)
        elsif @video.category == "Tv-series" || @video.category == "Reality-tv" || @video.category == "Talk-show" 
            search.resource('tv')
            search.query(@video.title)
        else
            search.resource('movie')
            search.query(@video.title)    
        end
        search_response = search.fetch
        if search_response.present?
            title = @video.title 
            object_count = search_response.count
            max_index = object_count -1
            hash_count = (0..max_index).to_a
            @poster_url = []
            hash_count.each do |i| # 'i' for index, count response array objects.
                object = search_response[i].fetch('title')
                if object == title
                    poster_path = search_response[i].fetch('poster_path')
                    if poster_path.present?
                        domain = "https://image.tmdb.org/t/p/w185" 
                        poster = domain << poster_path.to_s 
                        @poster_url.push(poster)
                    end
                end
            end
        end
    end
    helper_method :tmdb_poster_show

  	def genre_list
	    @genres = Video.pluck(:category).uniq   
  	end
  	def site_list
  	    @sites = Video.pluck(:site).uniq
  	end
end
