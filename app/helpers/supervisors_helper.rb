module SupervisorsHelper

	def can_become_supervisor? course
		return false if current_user.userable_type == "Student" || current_user.userable_type == "Staff"
		sp = course.supervisors.build
		sp.lecturer = current_user.userable
		can? :become_supervisor, sp
	end

	def can_create_supervisor? course
		supervisor = course.supervisors.new
		can? :create, supervisor
	end

	def printed
		"printed"
	end

	def waiting_approval_supervisors_counts
		raise CanCan::AccessDenied unless current_user.userable_type == "Lecturer"
		supervisors_unapprove = current_user.userable.supervisors.where{(approved == false)}
		supervisors_unapprove.size
	end
end
