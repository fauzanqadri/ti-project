class SeminarShowPdf < Prawn::Document
	delegate :params, :link_to, :number_to_currency, :raw, :content_tag, :current_user, :can?, to: :@view
	delegate :url_helpers, to: 'Rails.application.routes' 

	def initialize(view)
		super(:page_size => "A4")
		@view = view
		font "Times-Roman"
		# repeat :all do
		# 	stroke_axis 
		# end
		aspects_of_assessment
		assessment_form
		attendance_form
	end

	def skripsi
		@skripsi ||= Skripsi.find(params[:skripsi_id])
	end

	def seminar
		@seminar ||= skripsi.seminar
	end

	def supervisors
		@supervisors ||= skripsi.supervisors
	end


	def aspects_of_assessment
		supervisors.to_enum.with_index(1).each do |supervisor, i|
			text "Lembar-#{i}", align: :right, size: 10, inline_format: true
			text "Form Penilaian Seminar Skripsi", :align => :center, :size => 14, :inline_format => true, :style => :bold
			aspects_of_assessment_opening_part_one
			aspects_of_assessment_main_part_one
			aspects_of_assessment_bottom supervisor, i
			start_new_page if i != supervisors.size
		end
		supervisors.to_enum.with_index(1).each do |supervisor, i|
			start_new_page if i == 1
			text "Lembar-#{i}", align: :right, size: 10, inline_format: true
			text "Form Penilaian Seminar Skripsi", :align => :center, :size => 14, :inline_format => true, :style => :bold
			aspects_of_assessment_opening_part_two
			aspects_of_assessment_main_part_two
			aspects_of_assessment_bottom supervisor, i
			start_new_page if i != supervisors.size
		end
	end

	def assessment_form
		supervisors.to_enum.with_index(1).each do |supervisor, i|
			start_new_page if i == 1
			text "Lembar-#{i}", align: :right, size: 10, inline_format: true
			text "Form Seminar Skripsi", :align => :center, :size => 14, :inline_format => true, :style => :bold
			aspects_of_assessment_opening_part_one
			assessment_form_main
			assessment_form_bottom supervisor, i
			# aspects_of_assessment_bottom supervisor, i
			start_new_page if i != supervisors.size
		end
	end

	def attendance_form
		start_new_page
		text "ABSENSI PESERTA SEMINAR SKRIPSI", :align => :center, :size => 14, :inline_format => true, :style => :bold
		attendance_form_main_opening
		attendance_form_main
		attendance_form_bottom
	end

	def attendance_supervisor supervisors
	end

	def aspects_of_assessment_opening_part_one
		move_down 50
		bounding_box([0, cursor], width: bounds.width) do
			spv = supervisors.to_enum.with_index(1).map{|s, i| "#{i}. #{s.lecturer.to_s}"}.join("\n")
			data = [
				["NAMA", ":", "#{skripsi.student.to_s.upcase}"],
				["NIM", ":", "#{skripsi.student.nim}"], 
				["PROGRAM STUDI", ":", "#{skripsi.student.department.name}"],
				["JUDUL PENELITIAN", ":", {content: "#{skripsi.title}", align: :justify}],
				["DOSEN PEMBIMBING", ":", {content: spv}],
				["HARI/TANGGAL", ":", "#{skripsi.created_at.to_formatted_s(:long_ordinal)}"]
			]
			table(data,column_widths: [130], cell_style: {border_color: "FFFFFF", padding: [0,2,2,2]})
			move_down 15

		end
	end

	def aspects_of_assessment_main_part_one
		move_down 40
		bounding_box([0, cursor], width: bounds.width) do
			spv = supervisors.to_enum.with_index(1).map{|s, i| "#{i}. #{s.lecturer.to_s}"}.join("\n")
			data = [
				["NO", "ASPEK PENILAIAN", "NILAI"],
				["1", "Persiapan Seminar (15%)", ""],
				["2", "Sistematika Penyajian (20%)", ""],
				["3", "Kejelasan dalam memberikan terhadap pertanyaan, kritik, dan saran (20%)", ""],
				["4", "Penggunaan Alat Peraga (15%)", ""],
				["5", "Penampilan (15%)", ""],
				["6", "Sikap dalam menyajikan argumentasi (15%)", ""]
			]
			bounding_box([40, cursor], width: bounds.width) do
				text "Nilai Semester Skripsi (1 SKS)", :size => 10, :inline_format => true, :style => :italic
			end
			table(data, position: :center) do
				row(0).font_style   = :bold
				row(0).align   = :center
				column(0).align = :center
			end
		end
	end

	def aspects_of_assessment_bottom supervisor, index
		bounding_box([0, 250], width: bounds.width, height: 150) do
			# stroke_bounds
			# stroke_axis 
			bounding_box([50, cursor], width: 150, height: 150) do
				data = [
					[{content: "Keterangan Nilai", colspan: 3}],
					["A", ":", "80 - 100"],
					["B", ":", "70 - 79"],
					["C", ":", "60 - 69"],
					["D", "<=", "59"],
				]
				table(data, :column_widths => [20, 25, 105],  cell_style: {border_color: "ffffff", padding: [0,2,2,2]}) do
					row(0).font_style   = :bold
					column(1).align = :center
				end
			end
			bounding_box([bounds.width-200, cursor+150], width: 200, height: 150) do
				text "Jakarta, " + "." * 35
				text "Dosen Pembimbing #{index.to_roman}"
				move_down 70
				text "#{supervisor.lecturer.to_s}"
				text "NIP. #{supervisor.lecturer.nip}"
			end
		end
	end

	def aspects_of_assessment_opening_part_two
		move_down 50
		bounding_box([0, cursor], width: bounds.width) do
			spv = supervisors.to_enum.with_index(1).map{|s, i| "#{i}. #{s.lecturer.to_s}"}.join("\n")
			data = [
				["JUDUL PENELITIAN", ":", {content: "#{skripsi.title}", align: :justify}],
				["DOSEN PEMBIMBING", ":", {content: spv}],
				["HARI/TANGGAL", ":", "#{skripsi.created_at.to_formatted_s(:long_ordinal)}"]
			]
			table(data,column_widths: [130], cell_style: {border_color: "FFFFFF", padding: [0,2,2,2]})
			move_down 15
		end
	end

	def aspects_of_assessment_main_part_two
		move_down 70
		bounding_box([0, cursor], width: bounds.width) do
			spv = supervisors.to_enum.with_index(1).map{|s, i| "#{i}. #{s.lecturer.to_s}"}.join("\n")
			data = [
				[{content: "NAMA", rowspan: 2, font_style: :bold, align: :center}, {content: "NIM", rowspan: 2, font_style: :bold, align: :center}, {content: "Nilai", align: :center, font_style: :bold, colspan: 3}],
				[{content: "PRODI", font_style: :bold, align: :center}, {content: "ANGKA", font_style: :bold, align: :center}, {content: "HURUF", font_style: :bold, align: :center}],
				[{content: "#{skripsi.student.to_s}", align: :center},{content: "#{skripsi.student.nim}", align: :center}, {content: "#{skripsi.student.department.name}", align: :center}, "", ""]
			]
			bounding_box([15, cursor], width: bounds.width) do
				text "Nilai Semester Skripsi (1 SKS)", :size => 10, :inline_format => true, :style => :italic
			end
			table(data, position: :center, :column_widths => [130, 130, 120, 60, 60])
			# stroke_axis 
		end
	end

	def assessment_form_main
		move_down 60
		bounding_box([0, cursor], width: bounds.width) do
			text "SARAN/PERBAIKAN"
			move_down 10
			text "." * 1914
		end
		
	end

	def assessment_form_bottom supervisor, index
		bounding_box([0, 250], width: bounds.width, height: 150) do
			bounding_box([bounds.width-200, cursor], width: 200, height: 150) do
				text "Jakarta, " + "." * 35
				text "Dosen Pembimbing #{index.to_roman}"
				move_down 70
				text "#{supervisor.lecturer.to_s}"
				text "NIP. #{supervisor.lecturer.nip}"
			end
		end
	end

	def attendance_form_main_opening
		move_down 10
		bounding_box([0, cursor], width: bounds.width) do
			spv = supervisors.to_enum.with_index(1).map{|s, i| "#{i}. #{s.lecturer.to_s}"}.join("\n")
			data = [
				["NAMA", ":", "#{skripsi.student.to_s.upcase}"],
				["NIM", ":", "#{skripsi.student.nim}"], 
				["PROGRAM STUDI", ":", "#{skripsi.student.department.name}"],
				["JUDUL PENELITIAN", ":", {content: "#{skripsi.title}", align: :justify}],
				["DOSEN PEMBIMBING", ":", {content: spv}],
				["HARI/TANGGAL", ":", "#{skripsi.created_at.to_formatted_s(:long_ordinal)}"]
			]
			table(data,column_widths: [130], cell_style: {border_color: "FFFFFF", padding: [0,2,2,2]})
			move_down 10

		end
	end

	def attendance_form_main
		bounding_box([0, cursor], width: bounds.width) do
			data = [[{content: "NO", font_style: :bold, align: :center}, {content: "NAMA", font_style: :bold, align: :center}, {content: "NIM", font_style: :bold, align: :center}, {content: "Tanda Tangan", colspan: 2, font_style: :bold, align: :center}]]
			20.times do |i|
				i += 1
				if i.even?
					data << ["#{i}", "", "", "", "#{i}"]
				else
					data << ["#{i}", "", "", "#{i}", ""]
				end
				
			end
			bounding_box([40, cursor], width: bounds.width) do
				text "Nilai Semester Skripsi (1 SKS)", :size => 10, :inline_format => true, :style => :italic
			end
			table(data, position: :center, :column_widths => [50, 150, 100, 100, 100]) do
				column(0).align   = :center
			end
		end
	end

	def attendance_form_bottom
		bounding_box([0, 75], width: bounds.width, height: 150) do
			bounding_box([bounds.width-200, cursor], width: 200, height: 150) do
				sp_size = supervisors.size
				a = []
				sp_size.times {|i| a << (i+1).to_roman}
				text "Jakarta, " + "." * 35
				text "Dosen Pembimbing #{a.join("/")}"
				move_down 50
				text "..................................................."
				# line([0,0])
				text "NIP. "
			end
		end
	end

	def stroke_axis(options={})
  	options = { :height => (cursor - 20).to_i,
    	          :width => bounds.width.to_i
      	      }.merge(options)
  
		dash(1, :space => 4)
		stroke_horizontal_line(-21, options[:width], :at => 0)
		stroke_vertical_line(-21, options[:height], :at => 0)
		undash
  
		fill_circle [0, 0], 1
  
		(100..options[:width]).step(100) do |point|
			fill_circle [point, 0], 1
			draw_text point, :at => [point-5, -10], :size => 7
		end

		(100..options[:height]).step(100) do |point|
			fill_circle [0, point], 1
    	draw_text point, :at => [-17, point-2], :size => 7
  	end
	end

end