# Ajax
$(document).bind "ajaxSend", ->
	NProgress.start()
$(document).bind "ajaxComplete", ->
	NProgress.done()


NProgress.configure
  showSpinner: false
  ease: 'ease'
  speed: 500

# Refresh
$(document).ready ->
	NProgress.start()
hideCover = ()->
	NProgress.done()
	if $.turbo.isReady
		$('#cover').fadeOut 1000, ->
			$("#the-flash .alert").each (i, e)->
				$(@).delay(i*1000).fadeIn("slow")
$(window).load(hideCover)

# Turbo links
$(document).on "page:load", hideCover
$(document).on 'page:fetch', ->
	NProgress.start()
$(document).on "page:change", ->
	NProgress.done()
$(document).on "page:restore", ->
	NProgress.remove()
