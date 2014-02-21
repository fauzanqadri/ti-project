module ConcentrationsHelper
	def concentrations_opt
		concentrations = if current_user.userable_type != "Staff"
			id = current_user.userable.department_id
			Concentration.where{(department_id == id)}
		else
			id = current_user.userable.faculty_id
			Concentration.by_faculty(id)
		end
		concentrations.map{|concentration| [concentration.name, concentration.id]}
	end

	def concentration_availeble?
		concentrations = if current_user.userable_type != "Staff"
			current_user.userable.department.concentrations.any?
		else
			Concentration.by_faculty(id).any?
		end
	end

	def concentrations_select object, selected
		if concentration_availeble?
			content_tag :div, class: "form-group" do
				concat(raw(object.label(:konsentrasi, class: "col-sm-3 control-label")))
				concat(content_tag :div,raw(object.select(:concentration_id, options_for_select(concentrations_opt, selected: selected), {}, {class: "form-control"})),class: "col-sm-9")
			end
		end
	end
end
