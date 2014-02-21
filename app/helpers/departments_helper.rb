module DepartmentsHelper

	def departments_opt
		id = current_user.userable.faculty_id
		Department.where{(faculty_id.eq(id))}.map{|department| [department.name, department.id]}
	end
end
