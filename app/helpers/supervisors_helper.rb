module SupervisorsHelper

	def can_become_supervisor? course
		return false if current_user.userable_type == "Student"
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
end
