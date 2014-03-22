module ActAsCanImporting
	extend ActiveSupport::Concern

	class Importir

		def initialize import_id
			@import ||= Import.find(import_id)
		end

		def klass_delegation
			@klass_delegation ||= @import.klass_action.classify.constantize
		end

		def attr_import_delegated
			@attr_import_delegated ||= klass_delegation.attr_import_delegated
		end

		def copy_importir_attr
			@copy_importir_attr ||= klass_delegation.copy_importir_attr
		end

		def spreadsheet
			@spreadsheet ||= open_spreadsheet
		end

		def first_row
			@first_row ||= spreadsheet.first_row
		end

		def last_row
			@last_row ||= spreadsheet.last_row
		end

		def first_column
			@first_column ||= spreadsheet.first_column
		end

		def last_column
			@last_column ||= spreadsheet.last_column
		end

		def raw_data
			@import.update(status: "extracting", total_row: last_row-1)
			data = []
			(first_row+1..last_row).each do |i|
				attributes = {}
				(first_column..last_column).each do |j|
					key = attr_import_delegated.select{|k, v| v.key(spreadsheet.cell(first_row, j))}.keys.first
					if key
						attributes[key] = spreadsheet.cell(i, j)
					end
				end
				if !(attributes.nil? || attributes.blank?) && valid_attributes?(attributes)
					data << injected_attributes(attributes)
				end
			end
			data
		end

		def provide
			raw_data.each do |data|
				klass_delegation.find_or_initialize_by(data).tap do |t|
					t.save
				end
			end
			@import.update(status: "complete")
		end

		private

		def open_spreadsheet
			file = File.extname(@import.package.path)
			case file
			when '.csv' then Roo::CSV.new(@import.package.path)
			when '.xls' then Roo::Excel.new(@import.package.path)
			when '.xlsx' then Roo::Excelx.new(@import.package.path)
			else raise "Unknown file type: #{file.original_filename}"
			end
		end

		def valid_attributes? attributes
			required_status = []
			# true == true -> true
			# false == false -> true
			# true == false -> false
			# false == true -> true #special
			attributes.keys.each do |key|
				if attr_import_delegated[key][:required] == ( !attributes[key].nil? || !attributes[key].blank? ) # true == true -> true , false == false -> true, true == false -> false
					required_status << true
				elsif attr_import_delegated[key][:required] == false && ( !attributes[key].nil? || !attributes[key].blank? ) # false == true -> true # Special condition
					required_status << true
				else
					required_status << false
				end
			end
			!required_status.include? false
		end

		def injected_attributes attributes
			copy_importir_attr.each do |hash_attr|
				the_key = hash_attr.keys.first
				if hash_attr[the_key][:required] && (@import.respond_to?(hash_attr[the_key][:to]) && @import.send(hash_attr[the_key][:to]).present?)
					attributes[the_key] = @import.send(hash_attr[the_key][:to])
				elsif (hash_attr[the_key][:required] == false) && (@import.respond_to?(hash_attr[the_key][:to]) && @import.send(hash_attr[the_key][:to]).present?)
					attributes[the_key] = @import.send(hash_attr[the_key][:to])
				end
			end
			attributes
		end

	end

	class HardWorker
		include Sidekiq::Worker
		sidekiq_options :queue => :critical, :retry => false

		def perform import_id
			importir = Importir.new(import_id)
			importir.provide
		end

	end

	module ClassMethods

		module ActAsImportir

			def populate
				HardWorker.perform_async(self.id)
			end

		end

		def act_as_importir
			self.include(ActAsImportir)
		end

		def copy_importir_attr
			@copy_importir_attr ||= []
		end

		def attr_import_delegated
			@attr_import_delegated
		end

		def delegate_import_attr attr_list = {}
			@attr_import_delegated ||= attr_list
		end

		def delegate_copy_importir_attr attributes, *options
			copy_importir_attr << Hash[attributes, *options]
		end

	end

	
end

ActiveRecord::Base.send(:include, ActAsCanImporting)