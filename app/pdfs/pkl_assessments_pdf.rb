class PklAssessmentsPdf < Prawn::Document
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
		
		field_assessment_writing_report
		field_assessment_activity_report
		field_assessment_recap_report
	end

	def pkl
		@pkl ||= Pkl.find(params[:pkl_id])
	end

	def student
		@student ||= pkl.student
	end

	def department
		@department ||= student.department
	end

	def faculty
		@faculty ||= department.faculty
	end

	def supervisors
		@supervisors ||= pkl.supervisors.includes(:lecturer)
	end

	def pkl_assessments_asepect
		@pkl_assessments_asepect ||= PklAssessment.find_by(department_id: department.id)
	end

	def pkl_assessments_writing_asepect
		d_id = department.id
		@pkl_assessments_writing_asepect ||= PklAssessment.where{(category.eq("Penulisan")) & (department_id.eq(d_id))}
	end

	def pkl_assessments_activity_aspect
		d_id = department.id
		@pkl_assessments_activity_aspect ||= PklAssessment.where{(category.eq("Aktifitas")) & (department_id.eq(d_id))}
	end

	def department_setting
		@department_setting ||= department.setting
	end

	def department_director
		@department_director ||= Lecturer.find(department_setting.department_director)
	end

	def foramtted_time
		DateTime.now.strftime('%d %B %Y')
	end

	def field_assessment_writing_report
		supervisors.to_enum.with_index(1).each do |supervisor, i|
			start_new_page if i > 1
			assessment_report_header "PENILAIAN PKL PEMBIMBING BIDANG PENULISAN LAPORAN"
			assessment_report_opening
			field_assessment_report_content
			sp_count = 1 == supervisors.size ? nil : i
			assessment_report_bottom(sp_count, supervisor.lecturer.to_s, supervisor.lecturer.nip)
		end
	end

	def field_assessment_activity_report
		start_new_page
		assessment_report_header "PENILAIAN PKL PEMBIMBING BIDANG KEGIATAN"
		assessment_report_opening
		field_assessment_activity_report_content
		assessment_report_bottom
	end

	def field_assessment_recap_report
		start_new_page
		assessment_report_header "REKAP PENILAIAN PKL MAHASISWA"
		assessment_report_opening
		field_assessment_recap_content_report
		assessment_report_bottom(nil, department_director.to_s, department_director.nip)
	end

	def assessment_report_header text = nil
		bounding_box([0, cursor], width: 525, height: 117) do
			image_path = "#{Rails.root}/app/assets/images/uin_jkt.png"
			data = [
				[
					{ image: image_path, image_height: 50, image_width: 50, position: :center, vposition: :center, rowspan: 4 },
					{ content: "UNIVERSITAS ISLAM NEGRI", font_style: :bold },
					{ content: "FORM (FR)", font_style: :bold, rowspan: 4, align: :center },
					{ content: "No. Dok", size: 10 },
					{ content: ":", size: 10 },
					{ content: "AKM-FR-020", size: 10}
				],
				[
					{ content: "SYARIF HIDAYATULLAH JAKARTA", font_style: :bold },
					{ content: "Tgl. Terbit", size: 10 },
					{ content: ":", size: 10 },
					{ content: "#{foramtted_time}", size: 10 }
				],
				[
					{ content: "FAKULTAS #{faculty.name.upcase}", font_style: :bold },
					{ content: "No. Revisi", size: 10 },
					{ content: ":", size: 10 },
					{ content: "00", size: 10 }
				],
				[
					{ content: "Jl. ir. H. Juanda No 95 Ciputat 15412 Indonesia", size: 10, font_style: :italic },
					{ content: "Hal", size: 10 },
					{ content: ":", size: 10 },
					{ content: "1/1", size: 10 }
				],
				[
					{ content: "#{text}", colspan: 6, font_style: :bold, align: :center }
				]
			]
			table(data, position: :center) do
				row(0).columns(0).borders = [:top, :left]
				row(0).columns(1).padding = [2, 0, 0, 0]
				row(0).columns(1).borders = [:top]
				row(1).columns(1).padding = [2, 0, 0, 0]
				row(1).columns(1).borders = [:right]
				row(2).columns(1).padding = [2, 0, 0, 0]
				row(2).columns(1).borders = [:right]
				row(3).columns(1).padding = [2, 0, 0, 0]
				row(3).columns(1).borders = [:right]
				
				row(0).columns(2).padding = [35, 10, 0, 10]
				
				row(0).columns(3).borders = [:top]
				row(1).columns(3).borders = [:top]
				row(2).columns(3).borders = [:top]
				row(3).columns(3).borders = [:top]

				row(0).columns(4).borders = [:top]
				row(1).columns(4).borders = [:top]
				row(2).columns(4).borders = [:top]
				row(3).columns(4).borders = [:top]

				row(0).columns(5).borders = [:top, :right]
				row(1).columns(5).borders = [:top, :right]
				row(2).columns(5).borders = [:top, :right]
				row(3).columns(5).borders = [:top, :right]
			end
		end
	end

	def assessment_report_opening
		move_down 10
		bounding_box([25, cursor], width: 500, height: 200) do
			data1 = [
				["Nama", ":", "#{student.to_s}"],
				["Program Studi", ":", "#{department.name}"],
				["Tempat Pkl", ":", "................................................."],
				["Judul Laporan", ":", {content: pkl.title, align: :justify}]
			]
			data2 = [
				["Nim", ":", "#{student.nim}"],
				["Lama PKL", ":", ".............................."],
				["Semester", ":", ".............................."]
			]
			bounding_box([0, cursor], width: 300, height: 175) do
				table(data1, column_widths: [100], cell_style: {border_color: "FFFFFF", padding: [2,2,2,2]})
			end
			bounding_box([315, cursor+175], width: 200, height: 175) do
				table(data2, cell_style: {border_color: "FFFFFF", padding: [2,2,2,2]})
			end
		end
	end

	def field_assessment_report_content
		aspect_data = pkl_assessments_writing_asepect.to_enum.with_index(1).map { |s, i| ["#{i}", "#{s.aspect}", ""] }
		bottom_data = [
			[
				{
					content: "Jumlah",
					font_style: :bold,
					align: :right,
					colspan: 2
				},
				""
			],
			[
				{
					content: "Rata-rata",
					font_style: :bold,
					align: :right,
					colspan: 2
				},
				""
			],
		]
		data = [["NO", "ASPEK YANG DINILAI", "NILAI"]] + aspect_data + bottom_data
		bounding_box([25, cursor], width: 500) do
			table(data, column_widths: [45,250, 150], header: true, position: :center) do
				row(0).font_style = :bold
				row(0).align   = :center
				column(0).align = :center
			end
			move_down 10
			text "Keterangan: Nilai dalam bentuk angka/kuantitatif atau huruf/kualitatif dengan rentangan nilai", align: :center
			data_nilai = [["A = 80 - 100", "B = 70 - 79", "C = 60 - 69", "D = 0 - 59"]]
			table(data_nilai, position: :center, cell_style: {border_color: "FFFFFF", padding: [2, 20, 20, 2]})
		end
	end

	def field_assessment_activity_report_content
		aspect_data = pkl_assessments_activity_aspect.to_enum.with_index(1).map { |s, i| ["#{i}", "#{s.aspect}", ""] }
		bottom_data = [
			[
				{
					content: "Jumlah",
					font_style: :bold,
					align: :right,
					colspan: 2
				},
				""
			],
			[
				{
					content: "Rata-rata",
					font_style: :bold,
					align: :right,
					colspan: 2
				},
				""
			]
		]
		data = [["NO", "ASPEK YANG DINILAI", "NILAI"]] + aspect_data + bottom_data
		bounding_box([25, cursor], width: 500) do
			text_box "HASIL PENILAIAN KEGIATAN", at: [30, cursor]
			move_down 15
			table(data, column_widths: [45,250, 150], header: true, position: :center) do
				row(0).font_style = :bold
				row(0).align   = :center
				column(0).align = :center
			end
			move_down 10
			text "Keterangan: Nilai dalam bentuk angka/kuantitatif atau huruf/kualitatif dengan rentangan nilai", align: :center
			data_nilai = [["A = 80 - 100", "B = 70 - 79", "C = 60 - 69", "D = < 59"]]
			table(data_nilai, position: :center, cell_style: {border_color: "FFFFFF", padding: [2, 20, 20, 2]})
		end
	end

	def assessment_report_bottom supervisor_count = nil, supervisor_name = nil, nip = nil
		move_down 10
		bounding_box([25, cursor], width: 475, height: 125) do
			bounding_box([325, cursor], width: 150, height: 125) do
				text "Jakarta, #{foramtted_time}"
				text "Pembimbing #{supervisor_count.try(:to_romman)}"
				move_down 65
				text "#{supervisor_name}"
				line([0, cursor], [150, cursor])
				stroke
				move_down 4
				text "NIP. #{nip}"
			end
		end
	end

	def field_assessment_recap_content_report
		data = [
			["NO", "ASPEK PENILAIAN", "NILAI"], 
			["1", "Pembimbing Bidang Kegiatan", ""], 
			["2", "Pembimbing Bidang Penulisan Laporan", ""],
			[
				{
					content: "Jumlah",
					colspan: 2,
					font_style: :bold,
					align: :right
				}, ""
			],
			[
				{
					content: "Rata-rata / Nilai Akhir",
					font_style: :bold,
					align: :right,
					colspan: 2
				},
				""
			],
			[
				{
					content: "Huruf",
					font_style: :bold,
					align: :right,
					colspan: 2
				},
				""
			],
		]
		bounding_box([25, cursor], width: 500) do
			text_box "HASIL PENILAIAN", at: [30, cursor]
			move_down 15
			table(data, column_widths: [45,250, 150], header: true, position: :center) do
				row(0).font_style = :bold
				row(0).align   = :center
				column(0).align = :center
			end
			move_down 10
			text "Keterangan: Nilai dalam bentuk angka/kuantitatif atau huruf/kualitatif dengan rentangan nilai", align: :center
			data_nilai = [["A = 80 - 100", "B = 70 - 79", "C = 60 - 69", "D = < 59"]]
			table(data_nilai, position: :center, cell_style: {border_color: "FFFFFF", padding: [2, 20, 20, 2]})
		end
	end

end