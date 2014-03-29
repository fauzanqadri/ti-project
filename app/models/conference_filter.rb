class ConferenceFilter
	include ActiveModel::Model
	include ActiveModel::AttributeMethods


	attr_accessor :start, :ends, :type, :department_id
	validates_presence_of :start, :ends, :type
	validate :daterange

	def initialize attributes = {}
		attributes.each do |key, val|
			send("#{key}=", val)
		end
	end

	def attributes
		{start: start, ends: ends, type: type, department_id: department_id}
	end

	def persisted?
		false
	end

	private
	def daterange
		date1 = Date.parse(start) if start.present?
		date2 = Date.parse(ends) if ends.present?
		errors.add("Tanggal selesai", "tidak boleh sebelum tangal mulai") if (date1.nil? || date2.nil?) || (date2 < date1)
	end

end