# jQuery ->
#   $(".popup").popover()
#   $("a[rel~=tooltip], .has-tooltip").tooltip()
$(document).bind "DOMSubtreeModified", ()->
	$(".popup").popover()