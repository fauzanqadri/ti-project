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
	exms = []
	conference.examiners.includes(:lecturer).each do |examiner|
		lecturer_name = "#{examiner.lecturer.to_s}"
		delete_link = if can? :manage, Examiner
			" | #{link_to("<i class='fa fa-trash-o'></i> Hapus".html_safe, skripsi_sidang_examiner_path(conference.skripsi, conference, examiner), method: :delete, data: {confirm: "Konfirmasi penghapusan ?"})}".html_safe
		else
			""
		end
		exms << "<li>#{lecturer_name}#{delete_link}</li>".html_safe
	end
	# conference.examiners.includes(:lecturer).map{|examiner| ["<li>#{examiner.lecturer.to_s} | #{link_to("<i class='fa fa-trash-o'></i>".html_safe, skripsi_sidang_examiner_path(conference.skripsi, conference, examiner), class: 'btn btn-xs btn-danger', method: :delete, data: {confirm: "Konfirmasi penghapusan ?"})}</li>"]}.join("\n").html_safe
	exms.join("\n")
end
json.set! :examiners, examiners(@conference)
json.set! :manage_department_director_approval, can?(:manage_department_director_approval, @conference)
json.set! :manage_conference_examiners, can?(:manage_conference_examiners, @conference)

