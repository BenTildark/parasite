class TmdbController < ApplicationController

	def tmdb_self
	    query = params[:tmdb]
	    tv = params[:resource]
	    search = Tmdb::Search.new
	    if tv.present?
	      search.resource('tv')
	      search.query(query)
	    else
	      search.resource('movie')
	      search.query(query)
	    end
	    video = search.fetch
	    if video.present?
	      if video[0].key?('release_date')
	        release_date = video[0].fetch('release_date')
	        @year_m = release_date[0..3]
	      elsif video[0].key?('first_air_date')
	        air_date = video[0].fetch('first_air_date')
	        @year_t = air_date[0..3]
	      end
	      @description = video[0].fetch('overview')
	      @rating = video[0].fetch('vote_average')

	      video_id = video[0].fetch('id')
	      if tv.present?
	        cast = Tmdb::TV.cast(video_id)
	      else
	        detail_h = Tmdb::Movie.detail(video_id)
	        cast = Tmdb::Movie.casts(video_id)
	      end
	      if detail_h.present?
	        if detail_h.key?('runtime')
	          @run_time = detail_h.fetch('runtime')
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
end