class TrailerController < ApplicationController

	def trailer
	    query = params[:embed]
	    request_str = "https://www.youtube.com/results?search_query="
	    title_q = query.split.map(&:downcase).join('+')
	    trail_str = "+trailer"
	    search_query = request_str << title_q << trail_str
	    @search_q_str = search_query
	    doc = Nokogiri::HTML(open(search_query).read, nil, 'utf-8')
	    entry = doc.at_css('.yt-ui-ellipsis-2.spf-link')
	    li = "https://www.youtube.com/embed/"
	    href = entry['href']
	    nk = href.strip[9..19]
	    @embed_link = li << nk
	end

	def youtube_self
	    query = params[:self_embed]
	    request_str = "https://www.youtube.com/results?search_query="
	    title_q = query.split.map(&:downcase).join('+')
	    search_query = request_str << title_q 
	    doc = Nokogiri::HTML(open(search_query).read, nil, 'utf-8')
	    entry = doc.at_css('.yt-ui-ellipsis-2.spf-link')
	    li = "https://www.youtube.com/embed/"
	    href = entry['href']
	    nk = href.strip[9..19]
	    @embed_link = li << nk
	end
end