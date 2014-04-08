module FacultiesHelper
	def faculties_opt
		Faculty.all.map{|faculty| [faculty.name, faculty.id]}
	end

	def faculties_options selected = nil
		options_for_select(faculties_opt, selected: selected)
	end
end
