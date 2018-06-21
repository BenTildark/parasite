class VideosController < ApplicationController
	before_action :force_http, only: [:index, :show]
	before_action :set_video, only: [:show, :edit, :update, :destroy]
	
	def index
		if logged_in?
			if params[:tag].present?
      			@videos = Video.tagged_with(params[:tag]).paginate(page: params[:page], per_page: 20)
			elsif params[:category].present?
				genre_name = Video.find_by(category: params[:category]).category
      			@videos = Video.where(category: genre_name).paginate(page: params[:page], per_page: 20)
		    elsif params[:site].present?
		      	site_name = Video.find_by(site: params[:site]).site
		      	@videos = Video.where(site: site_name).order("created_at DESC").paginate(page: params[:page], per_page: 20)
		    elsif params[:search_title].present?
		    	@videos = Video.search_title(params[:search_title]).paginate(page: params[:page], per_page: 20)
		    elsif params[:search_tag].present?
		    	@videos = Video.search_tag(params[:search_tag]).paginate(page: params[:page], per_page: 20)
		    else
		      	@featured = Video.featured
		      	@videos = Video.all.order("created_at DESC").paginate(page: params[:page], per_page: 20)	
		    end
		else
			redirect_to login_url, notice: "Please sign in."
		end
	end

	def show
		if logged_in?
			tmdb
			if @video.site == "primewire.ag"
				tmdb_poster_show # only implemented if site primewire.ag (see show page for condition)
			end
			suggestions
		else
	      	redirect_to login_url, notice: "Please sign in."
	    end
	end

	def new
	    @video = Video.new
	end

	def edit
	end

	def create
	    @video = Video.new(video_params)

	    respond_to do |format|
	      if @video.save
	        format.html { redirect_to @video, notice: 'Video was successfully created.' }
	        format.json { render :show, status: :created, location: @video }
	      else
	        format.html { render :new }
	        format.json { render json: @video.errors, status: :unprocessable_entity }
	      end
	    end
	end

	def update
	    respond_to do |format|
	      if @video.update(video_params)
	        format.html { redirect_to @video, notice: 'Video was successfully updated.' }
	        format.json { render :show, status: :ok, location: @video }
	      else
	        format.html { render :edit }
	        format.json { render json: @video.errors, status: :unprocessable_entity }
	      end
	    end
	end

	def destroy
	    @video.destroy
	    respond_to do |format|
	      format.html { redirect_to videos_url, notice: 'Video was successfully destroyed.' }
	      format.json { head :no_content }
	    end
	end

	private
	# Use callbacks to share common setup or constraints between actions.
	def set_video
	    @video = Video.find(params[:id])
	end

	# Never trust parameters from the scary internet, only allow the white list through.
	def video_params
	    params.require(:video).permit(:title, :link, :img, :category, :site, :tag_list)
	end
end
# <span style="display:none"><%= text_field_tag :follow_link, params[:follow_link], id: "follow-links-input" %></span>
