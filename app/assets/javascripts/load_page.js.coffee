NProgress.configure
  ease: 'ease'
  speed: 500
  trickle: false

# Refresh
$(document).ready ->
	NProgress.start()
	$("#the-flash .alert").each (i, e)->
		$(@).delay(i*1000).fadeIn("slow")
			
$(window).load ->
	NProgress.done()
# Turbo links
$(document).on "page:load", ->
	NProgress.done()
	
$(document).on 'page:fetch', ->
	NProgress.start()
$(document).on "page:change", ->
	NProgress.done()
$(document).on "page:restore", ->
	NProgress.remove()
# Ajax
$(document).bind "ajaxSend", ->
	NProgress.start()
$(document).bind "ajaxComplete", ->
	NProgress.done()
