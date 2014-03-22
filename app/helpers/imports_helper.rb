module ImportsHelper
	def klass_action_opt
		Import::KLASS_ACTION.map{|str| [str, str]}
	end
end
