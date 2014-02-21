module FacultiesHelper
	def faculties_opt
		Faculty.all.map{|faculty| [faculty.name, faculty.id]}
	end
end
