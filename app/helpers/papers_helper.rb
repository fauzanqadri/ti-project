module PapersHelper
	def can_create_paper? course
		paper = course.papers.new
		can? :create, paper
	end
end