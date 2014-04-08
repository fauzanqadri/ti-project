class Post < ActiveRecord::Base
	has_paper_trail
	BOUNDABLE = ["Global", "Department", "Faculty"]
	belongs_to :userable, polymorphic: true
	before_validation :set_boundable

	validates_presence_of :title, :content, :boundable_type, :userable_type, :userable_id
	validates :boundable_type, inclusion: { in: BOUNDABLE }

	default_scope {order("created_at DESC")}

	scope :published, -> { where{(publish == true)} }
	scope :unpublished, -> { where{(publish == false)} }
	# scope :department, ->(department_id) { where{ (boundable_type == "Department") & (boundable_id.eq(department_id)) } }
	# scope :faculty, ->(faculty_id) { where{ (boundable_type == "Faculty") & (boundable_id.eq(faculty_id)) } }
	scope :accessible, ->(faculty_id, department_id) { where{ ((boundable_type == "Faculty") & (boundable_id.eq(faculty_id))) | ((boundable_type == "Department") & (boundable_id.eq(department_id))) |  (boundable_type == "Global")} }
	scope :global, -> { where{ (boundable_type == "Global") } }
	scope :search, ->(query) { where{ (title =~ "%#{query}%") | (content =~ "%#{query}%") } }


	def set_publish_status
		if self.publish?
			self.update(publish: false)
		else
			self.update(publish: true)
		end
	end

	def to_param
		"#{self.id}-#{self.title.parameterize}"
	end

	def bound
		return self.boundable_type if boundable_id.nil?
		kls = boundable_type.constantize
		return kls.find(boundable_id).name
	end


	private
	def set_boundable
		if self.userable_type == "Lecturer"
			self.boundable_type = "Department"
			self.boundable_id = self.userable.department_id
		end
	end
end
