class Ability
	include CanCan::Ability

	def initialize(user)
		@user ||= user
		if @user
			method = @user.userable_type.downcase
			if user.userable_type != "Staff"
				@setting ||= user.userable.department.setting
			end
			send(method)
		else
			cannot :manage, :all if user.nil?
			guest_user
		end
	end

	def guest_user
		can :read, Skripsi do |skripsi|
			skripsi.is_finish?
		end

		can :read, Pkl do |pkl|
			pkl.is_finish?
		end

		can :read, Paper do |paper|
			paper.course.is_finish?
		end

		can :read, Supervisor do |supervisor|
			supervisor.course.is_finish?
		end

		can :read, Feedback do |feedback|
			feedback.course.is_finish?
		end

		can :read, Consultation do |consultation|
			consultation.course.is_finish?
		end

		can :index, Conference do |conference|
			conference.skripsi.is_finish?
		end

		can :read, Report do |report|
			report.course.is_finish?
		end
	end

	def staff
		can :manage, Faculty
		can :manage, Department
		can :manage, Concentration
		can :manage, Staff
		can :manage, Lecturer
		can :manage, Student
		can :manage, Import
		can :conferences_report, Conference
		can :scheduled_conferences_report, Conference
		can :show_conferences_report, Conference
		can :manage, Post

		can :read, Course do |course|
			course.student.department.faculty_id == @user.userable.faculty_id || course.is_finish?
		end

		can :read, Paper do |paper|
			paper.course.student.department.faculty_id == @user.userable.faculty_id || paper.course.is_finish?
		end

		can :read, Supervisor do |supervisor|
			supervisor.course.student.department.faculty_id == @user.userable.faculty_id || supervisor.course.is_finish?
		end

		can :read, Feedback do |feedback|
			feedback.course.student.department.faculty_id == @user.userable.faculty_id || feedback.course.is_finish?
		end

		can :read, Consultation do |consultation|
			consultation.course.student.department.faculty_id == @user.userable.faculty_id || consultation.course.is_finish?
		end

		can :read, Conference do |conference|
			conference.skripsi.student.department.faculty_id == @user.userable.faculty_id || conference.skripsi.is_finish?
		end

		can :update, Conference do |conference|
			conference.skripsi.student.department.faculty_id == @user.userable.faculty_id
		end

		can :unmanaged_conferences, Conference

		can :manage_seminar_scheduling, Seminar do |seminar|
			seminar.skripsi.student.department.faculty_id == @user.userable.faculty_id
		end

		can :manage_sidang_scheduling, Sidang do |sidang|
			sidang.skripsi.student.department.faculty_id == @user.userable.faculty_id
		end

		can :show, Sidang do |sidang|
			sidang.skripsi.student.department.faculty_id == @user.userable.faculty_id && sidang.department_director_approval?
		end

		can :show, Seminar do |seminar|
			seminar.skripsi.student.department.faculty_id == @user.userable.faculty_id && seminar.department_director_approval?
		end

		can :set_local_sidang, Sidang do |sidang|
			sidang.skripsi.student.department.faculty_id == @user.userable.faculty_id
		end

		can :set_local_seminar, Seminar do |seminar|
			seminar.skripsi.student.department.faculty_id == @user.userable.faculty_id
		end

		can :read, Report do |report|
			report.course.student.department.faculty_id == @user.userable.faculty_id
		end

  end

	def student
		can :search, Lecturer
		can :read, Course

		can :create, Skripsi
		can :show, Skripsi do |skripsi|
			skripsi.student_id == @user.userable_id || skripsi.is_finish?
		end
		can :update, Skripsi, student_id: @user.userable_id
		can :destroy, Skripsi, student_id: @user.userable_id

		can :create, Pkl if @setting.allow_student_create_pkl?
		can :show, Pkl do |pkl|
			pkl.student_id == @user.userable_id || pkl.is_finish?
		end
		can :update, Pkl, student_id: @user.userable_id
		can :destroy, Pkl, student_id: @user.userable_id 

		can :read, PklAssessment

		can :create, Paper do |paper|
			paper.course.student_id == @user.userable_id
		end
		can :read, Paper do |paper|
			paper.course.student_id == @user.userable_id || paper.course.is_finish?
		end
		can :destroy, Paper do |paper|
			paper.course.student_id == @user.userable_id
		end

		can :read, Supervisor    
		can :create, Supervisor do |supervisor|
			supervisor.course.student_id == @user.userable_id
		end
		can :destroy, Supervisor do |supervisor|
			supervisor.approved == false && supervisor.course.student_id == @user.userable_id
		end

		can :read, Feedback
		can :create, Feedback do |feedback|
			feedback.course.student_id == @user.userable_id
		end
		can :destroy, Feedback do |feedback|
			feedback.userable_id == @user.userable_id && feedback.userable_type == @user.userable_type
		end

		can :read, Consultation

		can :index, Conference do |conference|
			conference.skripsi.student.department_id == @user.userable.department_id || conference.skripsi.is_finish?
		end

		can :show, Seminar do |seminar|
			(seminar.skripsi.student_id == @user.userable_id && seminar.department_director_approval?) || seminar.skripsi.is_finish?
		end

		can [:new, :create], Seminar do |seminar|
			sm = Seminar.find_by_skripsi_id(seminar.skripsi_id)
			sm.nil? && seminar.skripsi.student_id == @user.userable_id 
		end

		can :show, Sidang do |sidang|
			date_start = DateTime.parse(sidang.start.try(:to_s)) if sidang.start.present?
			date_now = DateTime.now.to_date
			(sidang.skripsi.student_id == @user.userable_id && sidang.department_director_approval?) && (!date_start.nil? && (date_now >= date_start.to_date)) || sidang.skripsi.is_finish?
		end

		can :create, Sidang do |sidang|
			sd = Sidang.find_by_skripsi_id(sidang.skripsi_id)
			sd.nil? && sidang.skripsi.student_id == @user.userable_id
		end

		can [:read, :create, :destroy], Report do |report|
			report.course.student_id == @user.userable_id
		end

	end

	def lecturer
		can :search, Lecturer
		can :read, Course
		can :read, Skripsi
		can :read, Pkl

		can :read, Paper

		can :read, Supervisor
		can :become_supervisor, Supervisor do |supervisor|
			supervisor = supervisor.course.supervisors.find_by(lecturer_id: @user.userable_id)
			supervisor.nil?
		end

		can :waiting_approval, Supervisor
		can :approve, Supervisor do |supervisor|
			supervisor.lecturer_id == @user.userable_id && supervisor.approved == false
		end
		can :destroy, Supervisor do |supervisor|
			if @setting.allow_remove_supervisor_duration == 0
				supervisor.lecturer_id == @user.userable_id && supervisor.approved == false
			else
				(supervisor.lecturer_id == @user.userable_id && supervisor.approved == false) || (supervisor.lecturer_id == @user.userable_id && supervisor.approved == true && (Time.now.to_i - supervisor.approved_time.to_i) < @setting.allow_remove_supervisor_duration.minutes)
			end
		end

		can :read, Feedback
		can :create, Feedback
		can :destroy, Feedback do |feedback|
			feedback.userable_id == @user.userable_id && feedback.userable_type == @user.userable_type
		end

		can :read, Consultation
		can :create, Consultation do |consultation|
			consultable_id = consultation.consultable_id
			l_id = @user.userable_id
			supervisors_id = consultation.course.supervisors.where{(lecturer_id == l_id)}.pluck(:id)
			supervisors_id.include?(consultable_id)
		end
		can :update, Consultation do |consultation|
			consultable_id = consultation.consultable_id
			l_id = @user.userable_id
			supervisors_id = consultation.course.supervisors.where{(lecturer_id == l_id)}.pluck(:id)
			supervisors_id.include?(consultable_id)
		end
		can :destroy, Consultation do |consultation|
			consultable_id = consultation.consultable_id
			l_id = @user.userable_id
			supervisors_id = consultation.course.supervisors.where{(lecturer_id == l_id)}.pluck(:id)
			supervisors_id.include?(consultable_id)
		end

		can :index, Conference do |conference|
			conference.skripsi.student.department_id == @user.userable.department_id || conference.skripsi.is_finish?
		end

		can :show, Seminar do |seminar|
			seminar.skripsi.supervisors.approved_supervisors.pluck(:lecturer_id).include?(@user.userable_id) && seminar.department_director_approval?
		end
		can :create, Seminar do |seminar|
			sm = Seminar.find_by_skripsi_id(seminar.skripsi_id)
			supervisors = seminar.skripsi.supervisors.approved_supervisors.pluck(:lecturer_id)
			sm.nil? && supervisors.include?(@user.userable_id)
		end

		can :show, Sidang do |sidang|
			sidang.skripsi.supervisors.approved_supervisors.pluck(:lecturer_id).include? @user.userable_id && sidang.department_director_approval?
		end

		can :create, Sidang do |sidang|
			sd = Sidang.find_by_skripsi_id(sidang.skripsi_id)
			supervisors = sidang.skripsi.supervisors.approved_supervisors.pluck(:lecturer_id)
			sd.nil? && supervisors.include?(@user.userable_id)
		end

		can :read, ConferenceLog
		can :approve, ConferenceLog

		can :manage, Surcease

		can [:read, :create, :destroy], Report do |report|
			supervisors = report.course.supervisors.approved_supervisors.pluck(:lecturer_id)
			supervisors.include?(@user.userable_id)
		end

		if @user.userable.is_admin?
			as_lecturer_admin
		end
	end

	def as_lecturer_admin
		can :manage, Lecturer
		can :manage, Student
		can :manage, Import
		can :new, PklAssessment
		can :conferences_report, Conference
		can :scheduled_conferences_report, Conference
		can :show_conferences_report, Conference
		can :manage, Post

		can [:create, :read, :update, :delete], PklAssessment do |pkl_assessment|
			pkl_assessment.department_id == @user.userable.department_id
		end
		# can :manage, PklAssessment

		can :create, Supervisor do |supervisor|
			supervisor.course.student.department_id == @user.userable.department_id && @user.userable_id == @user.userable.department.setting.department_director
		end
		
		can :destroy, Supervisor do |supervisor|
			supervisor.course.student.department_id == @user.userable.department_id && @user.userable_id == @user.userable.department.setting.department_director
		end

		can :show, Seminar
		can :show, Sidang

		can :unmanaged_conferences, Conference
		can :update, Conference do |conference|
			conference.skripsi.student.department_id == @user.userable.department_id
		end

		can :manage_department_director_approval, Conference do |conference|
			conference.skripsi.student.department_id == @user.userable.department_id
		end

		can :create, Examiner do |examiner|
			examiner.sidang.skripsi.student.department_id && @user.userable.department_id && examiner.sidang.examiners.size < @user.userable.department.setting.examiner_amount
		end

		can :destroy, Examiner do |examiner|
			examiner.sidang.skripsi.student.department_id && @user.userable.department_id
		end

		can :manage_conference_examiners, Conference do |conference|
			if conference.type == "Sidang"
			(conference.skripsi.student.department_id == @user.userable.department_id) && (conference.examiners.size < @user.userable.department.setting.examiner_amount)
			else
				false
			end
		end

		can :manage, Examiner
		can :manage_seminar_scheduling, Seminar do |seminar|
			seminar.skripsi.student.department_id == @user.userable.department_id && @user.userable.department.director_manage_seminar_scheduling?
		end
		can :manage_sidang_scheduling, Sidang do |sidang|
			sidang.skripsi.student.department_id == @user.userable.department_id && @user.userable.department.director_manage_sidang_scheduling?
		end
		can :set_local_sidang, Sidang do |sidang|
			sidang.skripsi.student.department_id == @user.userable.department_id && @user.userable.department.director_set_local_sidang?
		end
		can :set_local_seminar, Seminar do |seminar|
			seminar.skripsi.student.department_id == @user.userable.department_id && @user.userable.department.director_set_local_seminar?
		end
		can :manage, Setting
		can :manage, Assessment

		can :manage, Report do |report|
			report.course.student.department_id == @user.userable.department_id
		end
	end

end
