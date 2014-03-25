module DepartmentsHelper

	def departments_opt
		id = current_user.userable.faculty_id
		Department.where{(faculty_id.eq(id))}.map{|department| [department.name, department.id]}
	end

	def faculties
		@faculties ||= Faculty.all
	end

	def department_group_opt selected_value = nil
		option_groups_from_collection_for_select(faculties, :departments, :name, :id, :name, selected_value)
	end
end
