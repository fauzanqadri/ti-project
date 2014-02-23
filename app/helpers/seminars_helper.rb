module SeminarsHelper
	def can_create_seminar? skripsi
		seminar = Seminar.new(skripsi_id: skripsi.id)
		can? :create, seminar
	end
end
