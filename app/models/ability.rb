class Ability
  include CanCan::Ability

  def initialize(user)
    cannot :manage, :all if user.nil?
    @user ||= user
    method = @user.userable_type.downcase
    if user.userable_type != "Staff"
        @setting ||= user.userable.department.setting
    end
    send(method)
    # can :read, Faculty
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user 
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. 
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end

  def staff
    can :manage, Faculty
    can :manage, Department
    can :manage, Concentration
    can :manage, Staff
    can :manage, Lecturer
    can :manage, Student
  end

  def student
    can :search, Lecturer
    can :read, Course

    can :create, Skripsi
    can :show, Skripsi, student_id: @user.userable_id
    can :update, Skripsi, student_id: @user.userable_id
    can :destroy, Skripsi, student_id: @user.userable_id

    can :create, Pkl if @setting.allow_student_create_pkl?
    can :show, Pkl, student_id: @user.userable_id
    can :update, Pkl, student_id: @user.userable_id
    can :destroy, Pkl, student_id: @user.userable_id 

    can :create, Paper
    can :read, Paper
    can :destroy, Paper

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

    can :show, Seminar do |seminar|
        seminar.skripsi.student_id == @user.userable_id && seminar.department_director?
    end

    can :create, Seminar do |seminar|
        sm = Seminar.find_by_skripsi_id(seminar.skripsi_id)
        sm.nil?
    end

    can :show, Sidang do |sidang|
        sidang.skripsi.student_id == @user.userable_id
    end

    can :create, Sidang do |sidang|
        sd = Sidang.find_by_skripsi_id(sidang.skripsi_id)
        sd.nil?
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
        l_id = @user.userable_id
        lecturer_ids = supervisor.course.supervisors.pluck(:lecturer_id)
        !lecturer_ids.include?(l_id)
    end
    
    can :waiting_approval, Supervisor
    can :approve, Supervisor do |supervisor|
        supervisor.lecturer_id == @user.userable_id && supervisor.approved == false
    end
    can :destroy, Supervisor do |supervisor|
        if @setting.allow_remove_supervisor_duration == 0
            supervisor.lecturer_id == @user.userable_id && supervisor.approved == false
        else
            (supervisor.lecturer_id == @user.userable_id && supervisor.approved == false) || (supervisor.lecturer_id == @user.userable_id && supervisor.approved == true && (Time.now.to_i - supervisor.created_at.to_i) < @setting.allow_remove_supervisor_duration.minutes)
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

    can :show, Seminar do |seminar|
        seminar.skripsi.supervisors.approved_supervisors.pluck(:lecturer_id).include?(@user.userable_id) && seminar.department_director?
    end
    can :create, Seminar do |seminar|
        sm = Seminar.find_by_skripsi_id(seminar.skripsi_id)
        sm.nil?
    end

    can :show, Sidang do |sidang|
        sidang.skripsi.supervisors.approved_supervisors.pluck(:lecturer_id).include? @user.userable_id
        
    end

    can :create, Sidang do |sidang|
        sd = Sidang.find_by_skripsi_id(sidang.skripsi_id)
        sd.nil?
    end

    if @user.userable.is_admin?
        as_lecturer_admin
    end
  end

  def as_lecturer_admin
    can :create, Supervisor
    can :show, Seminar
    can :show, Sidang
    can :update, Conference
    can [:edit_department_director_approval, :update_department_director_approval], Conference do |conference|
        conference.skripsi.student.department_id == @user.userable.department_id
    end
    can :manage, Setting
  end

end
