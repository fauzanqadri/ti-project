module ConsultationsHelper
	def can_create_consultation? course
		return false if current_user.userable_type == "Student" || current_user.userable_type == "Staff"
		consultation = course.consultations.build
    supervisor = course.supervisors.find_by_lecturer_id(current_user.userable_id)
    consultation.consultable = supervisor
    can? :create, consultation
	end
end
