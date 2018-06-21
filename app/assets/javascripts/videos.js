$(document).on('turbolinks:load', function() {
  	$(function(){ 
  		$('.videos').imagesLoaded( function() {
  			$(this).masonry({
  				itemSelector: '.box',
  				isFitWidth: true
  			});
  		});
	});
});