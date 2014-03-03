class SidangShowPdf < Prawn::Document
	delegate :params, :link_to, :number_to_currency, :raw, :content_tag, :current_user, :can?, to: :@view
	delegate :url_helpers, to: 'Rails.application.routes' 

	def initialize view
		super(:page_size => "A4")
		@view = view
		aspects_of_assessment
		minutes_of_exam
	end

	def skripsi
		@skripsi ||= Skripsi.find(params[:skripsi_id])
	end

	def sidang
		@sidang ||= skripsi.sidang
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

	def supervisors
		@supervisors ||= skripsi.supervisors
	end

	def examiners
		@examiners ||= sidang.examiners
	end

	def setting
		@setting ||= department.setting
	end

	def assessments
		@assessments ||= department.assessments.where{(category.eq("Sidang"))}
	end

	def sekertaris_prodi
		@sekertaris_prodi ||= Lecturer.find(setting.department_secretary)
	end

	def ketua_prodi
		@ketua_prodi ||= Lecturer.find(setting.department_director)
	end

	def aspects_of_assessment
		supervisors.to_enum.with_index(1).each do |supervisor, i|
			text "Form Penilaian Skripsi Untuk Pembimbing", :align => :center, :size => 14, :inline_format => true, :style => :bold
			aspects_of_assessment_opening
			aspects_of_assessment_main
			aspects_of_assessment_bottom supervisor
			start_new_page if i != supervisors.size
		end
		examiners.to_enum.with_index(1).each do |examiner, i|
			start_new_page if i == 1
			text "Form Penilaian Skripsi Untuk Penguji", :align => :center, :size => 14, :inline_format => true, :style => :bold
			aspects_of_assessment_opening
			aspects_of_assessment_main
			aspects_of_assessment_bottom examiner
			start_new_page if i != examiners.size
		end
	end

	def aspects_of_assessment_opening
		spvs = supervisors.to_enum.with_index(1).map{|supervisor, i| ["#{i}. #{supervisor.lecturer.to_s}"] }.join("\n")
		exms = examiners.to_enum.with_index(1).map{|examiner, i| ["#{i}.#{examiner.try(:lecturer).try(:to_s)}"]}.join("\n")
		move_down 50
		bounding_box([0, cursor], width: bounds.width) do
			data = [
				["NAMA", ":", "#{skripsi.student.to_s.upcase}"],
				["NIM", ":", "#{skripsi.student.nim}"], 
				["PROGRAM STUDI", ":", "#{skripsi.student.department.name}"],
				["JUDUL", ":", {content: "#{skripsi.title}", align: :justify}],
				["PEMBIMBING", ":", {content: spvs}],
				["PENGUJI", ":", {content: exms}],
				["TANGGAL SIDANG", ":", "NOT IMPLEMENT YET"]
			]
			table(data,column_widths: [130], cell_style: {border_color: "FFFFFF", padding: [0,2,2,2]})
		end
	end

	def aspects_of_assessment_main
		move_down 20
		bounding_box([0, cursor], width: bounds.width) do
			assessments_data = assessments.to_enum.with_index(1).map{|assessment, i| ["#{i}", "#{assessment.aspect} (#{assessment.percentage}%)", ""]}
			text "PENILAIAN"
			data = [["NO", "ASPEK PENILAIAN", "NILAI"]] + assessments_data
			table(data, position: :center) do
				row(0).font_style   = :bold
				row(0).align   = :center
				column(0).align = :center
			end
		end
	end

	def aspects_of_assessment_bottom known
		move_down 20
		bounding_box([0, cursor], width: bounds.width) do
			text "Keterangan lainnya :"
			7.times do |i|
				text "." * 156 + "\n"
			end
		end
		move_down 20
		bounding_box([0, cursor], width: bounds.width, height: 150) do
			# stroke_bounds
			bounding_box([bounds.width-200, cursor], width: 200, height: 150) do
				# stroke_bounds
				timenow = Time.now.strftime("Jakarta, %d %B %Y")
				text "#{timenow}"
				signers = known.class.to_s == "Supervisor" ? "Pembimbing" : "Penguji"
				text "#{signers},"
				move_down 60
				text "#{known.lecturer.to_s}"
				text "NIP. #{known.lecturer.nip}"
			end
		end
	end

	def minutes_of_exam
		start_new_page
		text "BERITA ACARA UJIAN SKRIPSI / MUNAQOSAH", :align => :center, :size => 14, :inline_format => true, :style => :bold
		minutes_of_exam_opening
		minutes_of_exam_content
		minutes_of_exam_bottom
	end

	def minutes_of_exam_opening
		move_down 20
		bounding_box([0, cursor], width: bounds.width) do
			data = [
				["NAMA", ":", "#{skripsi.student.to_s.upcase}"],
				["NIM", ":", "#{skripsi.student.nim}"], 
				["PROGRAM STUDI", ":", "#{skripsi.student.department.name}"],
				["JUDUL", ":", {content: "#{skripsi.title}", align: :justify}],
				["TANGGAL", ":", "NOT IMPLEMENT YET"],
				["PEROLEHAN NILAI", ":", ""]
			]
			table(data,column_widths: [130], cell_style: {border_color: "FFFFFF", padding: [0,2,2,2]})
		end

	end

	def minutes_of_exam_content
		spvs = supervisors.to_enum.with_index(1).map{|supervisor, i| ["Pembimbing #{i.to_roman}", "#{supervisor.lecturer.to_s}", "", ""] }
		exms = examiners.to_enum.with_index(1).map{|examiner, i| ["Penguji #{i.to_roman}", "#{examiner.try(:lecturer).try(:to_s)}", "", ""]}
		data = [["Jabatan", "Nama", "Nilai", "Tanda Tangan"]] + spvs + exms
		bounding_box([150, cursor], width: bounds.width-150 , height: 130) do
			table(data, position: :center) do
				row(0).align = :center
			end
			# stroke_bounds
		end
		move_down 10
		data  = [["Hasil Ujian Rata - Rata", ":", ""]]
		table(data, column_widths: [130], cell_style: {border_color: "FFFFFF", padding: [0,2,2,2]})
		bounding_box([150, cursor], width: bounds.width-150 , height: 129) do
			data = [["Inti", ":", ".........."], ["KKN", ":", ".....(    /    )"], ["Seminar Skripsi", ":", "........(     /     )"], ["Skripsi", ":", "........(     /     )"], ["Jumlah", ":", ""]]
			table(data, cell_style: {border_color: "FFFFFF", padding: [0,2,2,2]})
			bounding_box([95, cursor], width: bounds.width-95	, height: 50) do
				data =
				[
					[
						{content: "IPK = ", rowspan: 2, align: :center},
						{content: "Jumlah KTN", rowspan: 1, align: :center},
						{content: " = ", rowspan: 2, align: :center},
						{content: "............", rowspan: 1, align: :center},
						{content: " = ............", rowspan: 2, align: :center}
					],
					[
						{content: "Jumlah SKS", rowspan: 1, align: :center}, 
						{content: "............", rowspan: 1, align: :center}
					]
				]
				table(data) do
					cells.borders = []
					column(0).padding = [16, 0,0, 0]
					row(0).column(1).borders = [:bottom]
					column(2).padding = [16, 0,0, 0]
					row(0).column(3).borders = [:bottom]
					column(4).padding = [16, 0,0, 0]
				end
			end
			# stroke_bounds
		end
		move_down 10
		text "Setelah melihat dan mempertimbangkan hasil inti, KKN, Seminar Skripsi dan Skripsi tersebut diatas, dengan ini Saudara dinyatakan : ", align: :justify, leading: 10
		text "LULUS / TIDAK LULUS / LULUS BERSYARAT", :align => :center, :size => 16, :inline_format => true, leading: 10
		text "Sebagai tanda lulus akan diserahkan kepada Saudara, Ijazah yang ditandatangani oleh Rektor dan Dekan untuk dipergunakan sebagai mestinya.", align: :justify, leading: 10
	end

	def minutes_of_exam_bottom
		move_down 10
		bounding_box([0, cursor], width: bounds.width , height: 130) do
			bounding_box([0, cursor], width: 250, height: 130) do
				text "*) Keterangan Yudisium", size: 10
				text "A = Dengan Pujian atau Kumlaude (IPK : 3,50 - 4,00)", size: 10
				text "B = Amat Baik (IPK 2,75 - 3,49)", size: 10
				text "C = Baik (IPK < 2,75)", size: 10
			end
			bounding_box([bounds.width-170, cursor+130], width: 170, height: 130) do
				text "Jakarta, " + "." * 35
				text "Dekan / Ketua Panitia"
				move_down 50
				text ".................................................."
				text "NIP. "
			end
		end
	end

end