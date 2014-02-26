module ConferencesHelper

	def last_conferences_agreement_counts
		raise CanCan::AccessDenied unless current_user.userable_type == "Lecturer"
		department_id = current_user.userable.department_id
		conferences = Conference.by_department(department_id).approved_supervisors.unapprove_department_director
		conferences.size
	end
end
