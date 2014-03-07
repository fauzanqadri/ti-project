module FeedbacksHelper

	def can_create_feedback? course
		fb = Feedback.new(course: course, userable: current_user.userable)
		can?(:create, fb)
	end
end