$(document).delegate "#the-flash .alert button.close", "click", (e)->
	parent = $(e.target).parent(".alert")
	parent.css
		"-moz-animation-duration": "3s"
		"-webkit-animation-duration": "3s"
	parent.addClass("animated slideOutRight")
	parent.one 'webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', ->
		$(this).remove()
$(document).delegate "#faculty-modal, #department-modal, #concentration-modal, #staff-modal, #staff-detail, #lecturer-modal, #lecturer-detail, #student-modal, #student-detail, #skripsi-modal, #pkl-modal, #paper-modal, #newPaper-modal, #supervisor-modal, #consultation-modal, #consultation-pdf-modal, #feedback-modal, #seminarReport-modal, #sidang-modal, #conference-modal, #seminar-modal", 'hidden.bs.modal', (e)->
	$(e.target).remove()

$(document).on 'click', "#fileSelect", ->
	$("#fileUpload").trigger('click')

$(document).on 'change', "#fileUpload", ->
	val = $(this).val()
	file = val.split(/[\\/]/)
	$("#filename").val(file[file.length-1])