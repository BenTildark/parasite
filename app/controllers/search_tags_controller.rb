class SearchTagsController < ApplicationController

	def tag_collection
		if logged_in?
			@tags = Video.tag_counts.paginate(:page => params[:page], :per_page => 200)
		else
			redirect_to login_url, notice: "Please sign in."
		end
	end
end