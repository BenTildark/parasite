class SearchTitleSuggestionsController < ApplicationController
	def index
		query = "%#{params[:term]}%"
	 	videos = Video.arel_table
	 	@search_title_suggestions = Video.where(videos[:title].matches(query)).limit(200)
	 	render json: @search_title_suggestions.map(&:title)	
	end
end
