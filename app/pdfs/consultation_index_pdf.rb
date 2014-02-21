class ConsultationIndexPdf < Prawn::Document
	delegate :params, :link_to, :number_to_currency, :raw, :content_tag, :current_user, :can?, to: :@view
	delegate :url_helpers, to: 'Rails.application.routes' 
	def initialize(view)
		super(:page_layout => :landscape, :page_size => "A4")
		@view = view
		@faculty = current_user.userable_type == "Staff" ? current_user.userable.faculty : current_user.userable.department.faculty
		font "Times-Roman"
		# repeat :all do
		# 	stroke_axis 
		# end
		header
		opening
		main_content
		sign_mark
	end

	private

	def header
		repeat :all do
			bounding_box([115, cursor+20], width: 550, height: 60) do
				image "#{Rails.root}/app/assets/images/uin_jkt.png", width: 65, :height => 60, at: [20, cursor]
				text_box "UNIVERSITAS ISLAM NEGRI", size: 16, align: :center, at: [0, cursor-5]
				text_box "SYARIF HIDAYATULLAH JAKARTA", size: 16, align: :center, at: [0, cursor-20]
				text_box "FAKULTAS #{@faculty.name.upcase}", size: 16, align: :center, at: [0, cursor-35]
			end
			bounding_box([115, cursor], width: 550, height: 45) do
				text_box "Jl. Ir. H. Juanda No. 95, Ciputat 15412, Indonesia", size: 9, at: [5, cursor-5]
				text_box "Telp. : (62-21)7493547, 7493606 Fax. : (62-21)7493315", size: 9, at: [5, cursor-17]
				text_box "Email : uinjkt@cabi.net.id", size: 9, at: [bounds.width.to_i-125, cursor-5]
				text_box "Website : #{@faculty.website}", size: 9, at: [bounds.width.to_i-132, cursor-17]
				stroke do
					horizontal_line 0, 525, at: cursor-30
					horizontal_line 0, 525, at: cursor-31
					horizontal_line 0, 525, at: cursor-34
				end
			end
		end
	end

	# def header
	# 	repeat :all do
	# 		bounding_box([0, cursor+20], width: 550, height: 60) do
	# 			image "#{Rails.root}/app/assets/images/uin_jkt.png", width: 65, :height => 60, at: [20, cursor]
	# 			text_box "UNIVERSITAS ISLAM NEGRI", size: 16, align: :center, at: [0, cursor-5]
	# 			text_box "SYARIF HIDAYATULLAH JAKARTA", size: 16, align: :center, at: [0, cursor-20]
	# 			text_box "FAKULTAS #{@faculty.name.upcase}", size: 16, align: :center, at: [0, cursor-35]
	# 		end
	# 		bounding_box([0, cursor], width: 550, height: 45) do
	# 			text_box "Jl. Ir. H. Juanda No. 95, Ciputat 15412, Indonesia", size: 9, at: [5, cursor-5]
	# 			text_box "Telp. : (62-21)7493547, 7493606 Fax. : (62-21)7493315", size: 9, at: [5, cursor-17]
	# 			text_box "Email : uinjkt@cabi.net.id", size: 9, at: [bounds.width.to_i-125, cursor-5]
	# 			text_box "Website : #{@faculty.website}", size: 9, at: [bounds.width.to_i-132, cursor-17]
	# 			stroke do
	# 				horizontal_line 0, 525, at: cursor-30
	# 				horizontal_line 0, 525, at: cursor-31
	# 				horizontal_line 0, 525, at: cursor-34
	# 			end
	# 		end
	# 	end
	# end

	def opening
		move_down 10
		repeat :all do
			text "Laporan Catatan Bimbingan", :align => :center, :size => 16, :inline_format => true, :style => :bold
			move_down 10
			bounding_box([20, cursor], width: bounds.width.to_i-20) do
				text "Nama mahasiswa : <b>#{course.student.full_name}</b>", :kerning => true, :inline_format => true
				text "Jurusan                 : <b>#{course.student.department.name}</b>", :kerning => true, :inline_format => true
				text "Judul #{course.class}        : - ", :kerning => true, :inline_format => true
				move_down 5
				text "<b>#{course.title.upcase}</b>",:kerning => true, :inline_format => true, :align => :center
			end
		end
	end

	def main_content
		bounding_box([0, cursor], width: bounds.width.to_i, height: 150) do
			data = [["Tanggal dibuat", "Pembuat", "Status", "Konsultasi berikutnya", "Saran / Arahan", "Tandatangan Dosen"]] + consultations
			# 765 pt
			# -146 pt
			table(data, :column_widths => [90, 153, 70, 153, 200, 99], :cell_style => {:align => :center}, :header => true) do
				row(0).font_style   = :bold
			end
		end
	end

	def sign_mark
		repeat :all do
			bounding_box([550, 120], width: 160, height: 110) do
				# stroke_bounds
				d = Time.now
				text "#{d.strftime("Jakarta, %d-%m-%Y")}"
				text "Sekertaris Prodi,"
				move_down 50
				text "Nurhayati, MT"
				text "NIP. 123456789098765432"
			end
		end
	end

	def course
		@course ||= Course.find(course_id)
	end

	def course_id
		return params[:skripsi_id] if params[:skripsi_id].present?
		return params[:pkl_id]
	end

	def consultations
		@consultations ||= course.consultations.map{|consultation| [consultation.created_at.to_date, consultation.consultable.lecturer.to_s, consultation.consultable_type, consultation.next_consult.try(:to_formatted_s, :long_ordinal), consultation.content, ""]}
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