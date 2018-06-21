$(document).on "turbolinks:load", ->
	
	$('#videos-search').autocomplete
		source: $('#videos-search').data('autocomplete-source')
		 
			
	$('#tags-search').autocomplete
		source: $('#tags-search').data('autocomplete-source')			

	