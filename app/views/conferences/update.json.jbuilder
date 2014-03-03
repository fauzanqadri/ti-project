json.(@conference, :id, :tanggal, :mulai, :selesai, :start, :end, :local, :type, :department_director_approval, :color)
json.skripsi do |json|
	json.(@conference.skripsi, :title)
	json.student do |json|
		json.(@conference.skripsi.student, :full_name)
	end
	json.set! :supervisors, @conference.skripsi.supervisors.approved_supervisors.map{|supervisor| "<li>#{supervisor.lecturer.to_s}</li>"}.join("\n")
end