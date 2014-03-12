class SeminarShowPdf < Prawn::Document
	delegate :params, :link_to, :number_to_currency, :raw, :content_tag, :current_user, :can?, to: :@view
	delegate :url_helpers, to: 'Rails.application.routes' 

	def initialize(view)
		super(:page_size => "A4")
		@view = view
		font "Times-Roman"
		repeat :all do
			# stroke_axis 
			# stroke_bounds
		end
		borrowing_local_letters
		aspects_of_assessment
		assessment_form
		attendance_form
		attendance_supervisor
	end

	def skripsi
		@skripsi ||= Skripsi.find(params[:skripsi_id])
	end

	def student
		@student ||= skripsi.student
	end

	def department
		@department ||= student.department
	end

	def faculty
		@faculty ||= department.faculty
	end

	def seminar
		@seminar ||= skripsi.seminar
	end

	def assessments
		@assessments ||= department.assessments.where{(category.eq("Seminar"))}.order("percentage asc")
	end

	def supervisors
		@supervisors ||= skripsi.supervisors
	end

	def setting
		@setting ||= department.setting
	end

	def ketua_prodi
		@ketua_prodi ||= Lecturer.find(setting.department_director)
	end

	def sekertaris_prodi
		@sekertaris_prodi ||= Lecturer.find(setting.department_secretary)
	end

	def borrowing_local_letters
		borrowing_local_letter_header
		borrowing_local_letter_opening
		borrowing_local_letter_content
		borrowing_local_letter_footer
	end

	def borrowing_local_letter_header
		bounding_box([0, cursor+20], width: 550, height: 60) do
			image "#{Rails.root}/app/assets/images/uin_jkt.png", width: 65, :height => 60, at: [20, cursor]
			text_box "UNIVERSITAS ISLAM NEGRI", size: 16, align: :center, at: [0, cursor-5]
			text_box "SYARIF HIDAYATULLAH JAKARTA", size: 16, align: :center, at: [0, cursor-20]
			text_box "FAKULTAS #{faculty.name.upcase}", size: 16, align: :center, at: [0, cursor-35]
		end
		bounding_box([0, cursor], width: 550, height: 45) do
			text_box "Jl. Ir. H. Juanda No. 95, Ciputat 15412, Indonesia", size: 9, at: [5, cursor-5]
			text_box "Telp. : (62-21)7493547, 7493606 Fax. : (62-21)7493315", size: 9, at: [5, cursor-17]
			text_box "Email : uinjkt@cabi.net.id", size: 9, at: [bounds.width.to_i-172, cursor-5]
			text_box "Website : #{faculty.website}", size: 9, at: [bounds.width.to_i-172, cursor-17]
			stroke do
				horizontal_line 0, 525, at: cursor-30
				horizontal_line 0, 525, at: cursor-31
				horizontal_line 0, 525, at: cursor-34
			end
		end
	end

	def borrowing_local_letter_opening
		move_down 5
		bounding_box([0, cursor], width: 525, height: 50) do
			data = [["Nomor", ":", "Istimewa"], ["Lamp", ":", "1 Eks."], ["Hal", ":", "Peminjaman Ruang"]]
			table(data, cell_style: {border_color: "FFFFFF", padding: [0,2,2,2]})
			text_box "Jakarta, #{DateTime.now.strftime('%d %B %Y')}", size: 12, at: [bounds.width.to_i-150, cursor+44]
			# stroke_bounds
		end
		move_down 15
		bounding_box([45, cursor], width: 475, height: 100) do
			text "Kepada Yth ."
			text "Kebag TU Fakultas #{faculty.name}"
			text "UIN Syarif Hidayatullah Jakarta"
			text "Di    -"
			text_box "Tempat", size: 12, at: [23, cursor]
			text_box "Assalamu'alaikum Wr. Wb", size: 12, at: [0, cursor-30]
			# stroke_bounds
		end
	end

	def borrowing_local_letter_content
		move_down 10
		bounding_box([45, cursor], width: 475, height: 250) do
			text "#{Prawn::Text::NBSP * 10}" + "Sehubungan dengan adanya Seminar Hasil Skripsi Mahasiswa Program Studi " + 
			"#{department.name} Fakultas #{faculty.name} Universitas Islam Negri Syarif Hidayatullah Jakarta.", 
			align: :justify, leading: 10
			# move_down 15
			data = [["Nama", ":", "#{student.to_s}"], ["Nim", ":", "#{student.nim}"]]
			table(data, position: 26, cell_style: {border_color: "FFFFFF", padding: [0,2,2,2]})
			move_down 15
			text "#{Prawn::Text::NBSP * 10}" + "Untuk mengadakan acara tersebut perlu adanya ruangan. Adapun acara tersebut, " +
			"Insya Allah akan dilaksanakan pada :", align: :justify, leading: 10
			data = [["Hari / Tanggal", ":", "#{seminar.tanggal}"], ["Pukul", ":", "#{seminar.mulai} - #{seminar.selesai} WIB"], ["Tempat", ":", "Ditentukan Fakultas"]]
			table(data, position: 26, cell_style: {border_color: "FFFFFF", padding: [0,2,2,2]})
			move_down 15
			text "#{Prawn::Text::NBSP * 10}" + "Demikian, atas perhatian dan kerjasamanya kami mengucapkan terimakasih.", align: :justify, leading: 10
			text "Wassalamu'alaikum Wr. Wb"
		end
	end

	def borrowing_local_letter_footer
		bounding_box([0, 250], width: bounds.width, height: 150) do
			# stroke_bounds
			# stroke_axis 
			bounding_box([bounds.width-200, cursor], width: 200, height: 150) do
				text "A.n Ketua Prodi"
				text "Sekretaris"
				move_down 70
				text "#{sekertaris_prodi.to_s}"
				text "NIP. #{sekertaris_prodi.nip}"
				# stroke_bounds
			end
		end
	end


	def aspects_of_assessment
		supervisors.to_enum.with_index(1).each do |supervisor, i|
			start_new_page if i == 1
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

	def attendance_supervisor
		start_new_page(:layout => :landscape)
		text "ABSENSI DOSEN SEMINAR SKRIPSI", :align => :center, :size => 14, :inline_format => true, :style => :bold
		text "PROGRAM STUDI #{skripsi.student.department.name.upcase}", :align => :center, :size => 14, :inline_format => true, :style => :bold
		attendance_supervisor_main
		attendance_supervisor_bottom
	end

	def attendance_supervisor_main
		move_down 50
		bounding_box([0, cursor], width: bounds.width) do
			data = [
				[
					{content: "NO", font_style: :bold, align: :center},
					{content: "NAMA", font_style: :bold, align: :center},
					{content: "NIM", font_style: :bold, align: :center},
					{content: "JUDUL SKRIPSI", font_style: :bold, align: :center},
					{content: "HARI/TANGGAL", font_style: :bold, align: :center},
					{content: "DOSEN PEMBIMBING", font_style: :bold, align: :center},
					{content: "TTD", font_style: :bold, align: :center},
				]
			]
			sp_size = supervisors.size
			supervisors.to_enum.with_index(1).each do |supervisor, i|
				if i == 1
					data << [
						{content: "", rowspan: sp_size},
						{content: "#{skripsi.student.to_s}", rowspan: sp_size, align: :center},
						{content: "#{skripsi.student.nim}", rowspan: sp_size, align: :center},
						{content: "#{skripsi.title.upcase}", rowspan: sp_size},
						{content: "#{seminar.tanggal}", rowspan: sp_size},
						{content: "#{i}. #{supervisor.lecturer.to_s}"},
						{content: ""}
					]
				else
					data << [
						{content: "#{i}. #{supervisor.lecturer.to_s}"},
						{content: ""}
					]
				end
				
			end
			table(data, position: :center, :column_widths => [30, 120, 100, 200, 105, 120, 94])
		end
	end

	def attendance_supervisor_bottom
		bounding_box([50, cursor-100], width: 150, height: 150) do
			bounding_box([bounds.width+300, cursor], width: 200, height: 150) do
				sp_size = supervisors.size
				a = []
				sp_size.times {|i| a << (i+1).to_roman}
				text "Jakarta, " + "." * 35
				text "Dosen Pembimbing #{a.join("/")}"
				move_down 70
				text "..................................................."
				# line([0,0])
				text "NIP. "			end
		end
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
				["HARI/TANGGAL", ":", "#{seminar.tanggal}"]
			]
			table(data,column_widths: [130], cell_style: {border_color: "FFFFFF", padding: [0,2,2,2]})
			move_down 15

		end
	end

	def aspects_of_assessment_main_part_one
		move_down 40
		bounding_box([0, cursor], width: bounds.width) do
			spv = supervisors.to_enum.with_index(1).map{|s, i| "#{i}. #{s.lecturer.to_s}"}.join("\n")
			assessments_data = assessments.to_enum.with_index(1).map{|assessment, i| ["#{i}", "#{assessment.aspect} (#{assessment.percentage}%)", ""]}
			data = [["NO", "ASPEK PENILAIAN", "NILAI"]] + assessments_data
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
				["HARI/TANGGAL", ":", "#{seminar.tanggal}"]
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
				["HARI/TANGGAL", ":", "#{seminar.tanggal}"]
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