module ConferenceLogsHelper
	def conference_logs_count
		raise CanCan::AccessDenied unless current_user.userable_type == "Lecturer"
		conference_logs = current_user.userable.conference_logs.where{(approved == false)}
		conference_logs.size
	end
end
