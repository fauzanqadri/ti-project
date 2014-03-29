class ScheduledConferencesReportPdf < Prawn::Document
	delegate :params, :link_to, :number_to_currency, :raw, :content_tag, :current_user, :can?, to: :@view
	delegate :url_helpers, to: 'Rails.application.routes' 


	def initialize view
		super(:page_size => "A4", page_layout: :landscape)
		@view = view
		font "Times-Roman"
		repeat :all do
			# stroke_axis 
			# stroke_bounds
		end
		if params[:type] == "Sidang"
			sidang_report
		else
			seminar_report
		end
	end

	def userable
		@userable ||= current_user.userable
	end

	def department
		if userable.class == Staff
			@department ||= Department.find(params[:department_id])
		else
			@department ||= userable.department
		end
	end

	def setting
		@setting ||= department.setting
	end

	def department_director
		@department_director ||= Lecturer.find(setting.department_director)
	end

	def faculty
		@faculty ||= department.faculty
	end

	def conferences
		if params[:type] == "Sidang"
			@conferences ||= Sidang.includes(skripsi: [:student, {supervisors: :lecturer}], examiners: :lecturer).by_department(department.id).approved_department_director.assign_local.daterange(params[:start], params[:end])
		else
			@conferences ||= Seminar.includes(skripsi: [:student, {supervisors: :lecturer}]).by_department(department.id).approved_department_director.assign_local.daterange(params[:start], params[:end])
		end
	end

	def skripsi_supervisors conference
		conference.skripsi.supervisors.approved_supervisors.to_enum.with_index(1).map {|supervisor, i| "#{i}. #{supervisor.lecturer.to_s}"}.join("\n")
	end

	def sidang_examiner conference
		conference.examiners.to_enum.with_index(1).map {|examiner, i| "#{i}. #{examiner.lecturer.to_s}"}.join("\n")
	end

	def foramtted_time time
		DateTime.parse(time.to_s).strftime('%d %B %Y')
	end

	def get_time time
		DateTime.parse(time.to_s).strftime('%H:%M')
	end

	def get_day time
		DateTime.parse(time.to_s).strftime('%A')
	end

	def report_header title
		repeat :all do
			text title, align: :center, size: 11
			text "FAKULTAS #{faculty.name.upcase}", align: :center, size: 11
			text "UIN SYARIF HIDAYATULLAH JAKARTA", align: :center, size: 11
		end
	end

	def report_bottom
		repeat :all do
			move_down 10
			bounding_box([0, cursor], width: bounds.width.to_i, height: 125) do
				bounding_box([600, cursor], width: 150, height: 125) do
					text "Jakarta, #{foramtted_time(DateTime.now)}", size: 11
					text "a.n. Dekan", size: 11
					text "Ketua Prodi #{department.name}", size: 11
					move_down 65
					text "#{department_director.to_s}", size: 11
					text "NIP. #{department_director.nip}", size: 11
				end
			end
		end
	end

	def sidang_report_content
		move_down 5
		bounding_box([0, cursor], width: bounds.width.to_i, height: 325) do
			text "Program Studi : #{department.name}", size: 10
			conferences_data = conferences.to_enum.with_index(1).map do |conference, i| 
				[
					"#{i}",
					"#{conference.skripsi.student.to_s}\n#{conference.skripsi.student.try(:phone_number)}",
					conference.skripsi.student.nim,
					get_day(conference.start),
					foramtted_time(conference.start),
					"#{get_time(conference.start)} - #{get_time(conference.end)}",
					conference.local,
					conference.skripsi.title.try(:truncate, 50),
					skripsi_supervisors(conference),
					sidang_examiner(conference)
				]
			end
			data = [["NO", "NAMA MAHASISWA", "NIM", "HARI", "TANGGAL", "JAM", "LOKAL", "JUDUL", "PEMBIMBING", "PENGUJI"]] + conferences_data
			table(data, :column_widths => [30, 113, 70, 45, 66, 65, 50, 90, 120, 120], :cell_style => {:align => :center, size: 10}, :header => true) do
				row(0).font_style   = :bold
				columns(7).align = :justify
				columns(8).align = :left
				columns(9).align = :left
				row(0).columns(7).align = :center
				row(0).columns(8).align = :center
				row(0).columns(9).align = :center
			end
		end
	end

	def seminar_report_content
		move_down 5
		bounding_box([0, cursor], width: bounds.width.to_i, height: 325) do
			text "Program Studi : #{department.name}", size: 10
			conferences_data = conferences.to_enum.with_index(1).map do |conference, i| 
				[
					"#{i}",
					"#{conference.skripsi.student.to_s}\n#{conference.skripsi.student.try(:phone_number)}",
					conference.skripsi.student.nim,
					get_day(conference.start),
					foramtted_time(conference.start),
					"#{get_time(conference.start)} - #{get_time(conference.end)}",
					conference.local,
					conference.skripsi.title.try(:truncate, 50),
					skripsi_supervisors(conference),
				]
			end
			data = [["NO", "NAMA MAHASISWA", "NIM", "HARI", "TANGGAL", "JAM", "LOKAL", "JUDUL", "PEMBIMBING"]] + conferences_data
			table(data, :column_widths => [35, 113, 70, 65, 75, 85, 50, 145, 131], :cell_style => {:align => :center, size: 10}, :header => true) do
				row(0).font_style   = :bold
				columns(7).align = :justify
				columns(8).align = :left
				columns(9).align = :left
				row(0).columns(7).align = :center
				row(0).columns(8).align = :center
			end
		end
	end

	def sidang_report
		report_header "JADWAL UJIAN SKRIPSI"
		sidang_report_content
		report_bottom	
	end

	def seminar_report
		report_header "JADWAL SEMINAR SKRIPSI"
		seminar_report_content
		report_bottom	
	end
	
end