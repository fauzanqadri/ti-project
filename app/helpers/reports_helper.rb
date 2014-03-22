module ReportsHelper
	def can_create_report? course
		report = course.reports.new
		can? :create, report
	end
end
