class StaticPagesController < ApplicationController
	skip_before_filter :authenticate_user!, only: [:published_courses, :get_faculties, :get_departments, :get_concentrations]
	skip_before_filter :checking_setting!
	skip_before_filter :checking_assessment!
	
	def index
		render template: "static_pages/#{current_user.userable_type.downcase}"
	end

	def published_courses
		respond_to do |format|
			format.html
			format.json {render json: PublishedCoursesDatatable.new(view_context)}
		end
	end

	def get_faculties
		@faculties = Faculty.all
	end

	def get_departments
		@faculty = Faculty.find(params[:faculty_id])
		@departments = @faculty.departments
	end

	def get_concentrations
		@department = Department.find(params[:department_id])
		@concentrations = @department.concentrations
	end

	def profile
		@user = current_user.userable
		respond_to do |format|
			format.js
		end
	end

	def update_profile
		@user = current_user.userable
		respond_to do |format|
			if @user.update(send("#{@user.class.to_s.downcase}_params"))
				flash[:notice] = "Update profile berhasil"
				format.js
			else
				format.js { render action: 'profile' }
			end
			
		end
	end

	def account
		@account = current_user
		respond_to do |format|
			format.js
		end
	end

	def update_account
		@account = current_user
		respond_to do |format|
			if @account.update(account_params)
				flash[:notice] = "Update account berhasil"
				format.js
			else
				format.js { render action: 'account'}
			end
		end
	end

	def password
		@account = current_user
		respond_to do |format|
			format.js
		end
	end

	def update_password
		@account = current_user
		respond_to do |format|
			if @account.update(password_params)
				flash[:notice] = "Update password berhasil"
				format.js
			else
				format.js { render action: 'password'}
			end
		end
	end

	private

	def staff_params
		params.require(:staff).permit(:full_name, :address, :born)
	end

	def student_params
		params.require(:student).permit(:full_name, :address, :born)
	end

	def lecturer_params
		params.require(:lecturer).permit(:nip, :nid, :full_name, :address, :born, :level, :front_title, :back_title)
	end

	def account_params
		params.require(:user).permit(:email, :username)
	end

	def password_params
		params.require(:user).permit(:password, :password_confirmation)
	end

end
