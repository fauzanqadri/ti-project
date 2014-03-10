module SurceasesHelper

	def surceases_unapprove_count
		raise CanCan::AccessDenied.new unless current_user.userable_type == "Lecturer"
		lecturer = current_user.userable_id
		surceases = Surcease.by_lecturer(lecturer).unfinish
		surceases.size
	end
end
