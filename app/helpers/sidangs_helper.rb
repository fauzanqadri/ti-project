module SidangsHelper

	def can_create_sidang? skripsi
		sidang = Sidang.new(skripsi_id: skripsi.id)
		can? :create, sidang
	end
end
