json.(@conference, :id, :tanggal, :mulai, :selesai, :start, :end, :local, :type, :department_director_approval, :color)
json.skripsi do |json|
	json.(@conference.skripsi, :title)
	json.student do |json|
		json.(@conference.skripsi.student, :full_name)
	end
	json.set! :supervisors, @conference.skripsi.supervisors.approved_supervisors.map{|supervisor| "<li>#{supervisor.lecturer.to_s}</li>"}.join("\n")
	json.department do |json|
		json.set! :name, @conference.skripsi.student.department.name
	end
	json.set! :url, skripsi_path(@conference.skripsi)
end
def examiners conference
	return nil if conference.type == "Seminar"
	conference.examiners.includes(:lecturer).map{|examiner| ["<li>#{examiner.lecturer.to_s} | #{link_to("<i class='fa fa-trash-o'></i>".html_safe, skripsi_sidang_examiner_path(conference.skripsi, conference, examiner), class: 'btn btn-xs btn-danger', method: :delete, data: {confirm: "Konfirmasi penghapusan ?"})}</li>"]}.join("\n").html_safe
end
json.set! :examiners, examiners(@conference)

