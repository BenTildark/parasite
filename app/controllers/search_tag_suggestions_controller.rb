class SearchTagSuggestionsController < ApplicationController
	def index
		query = "%#{params[:term]}%"
	 	tags = Tag.arel_table
	 	@search_tag_suggestions = Tag.where(tags[:name].matches(query)).limit(200)
	 	render json: @search_tag_suggestions.map(&:name)	
	end
end