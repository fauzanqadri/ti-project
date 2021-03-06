class StaticPagesController < ApplicationController
	skip_before_filter :authenticate_user!, only: [:published_courses, :get_faculties, :get_departments, :get_concentrations, :avatar]
	skip_before_filter :checking_setting!
	skip_before_filter :checking_assessment!
	
	def index
		render template: "static_pages/dashboard/#{current_user.userable_type.downcase}"
	end

	def published_courses
		respond_to do |format|
			format.html
			format.json {render json: PublishedCoursesDatatable.new(view_context)}
		end
	end

	def get_faculties
		@faculties = Faculty.all
		respond_to do |format|
			format.json
		end
	end

	def get_departments
		@faculty = Faculty.find(params[:faculty_id])
		@departments = @faculty.departments
		respond_to do |format|
			format.json
		end
	end

	def get_concentrations
		@department = Department.find(params[:department_id])
		@concentrations = @department.concentrations
		respond_to do |format|
			format.json
		end
	end

	def avatar
		avatar = Avatar.find(params[:id])
		size = params[:style].presence || "large"
		send_file avatar.image.path(size.to_sym), type: avatar.image_content_type, disposition: "inline"
	end

	def profile
		@user = current_user.userable
		@avatar = @user.avatar.presence || @user.build_avatar
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


	def student_help
	end

	def lecturer_help
	end

	def staff_help
	end

	def admin_help
	end

	private

	def staff_params
		params.require(:staff).permit(:full_name, :address, :born, avatar_attributes: [:id, :image])
	end

	def student_params
		params.require(:student).permit(:full_name, :address, :born, :home_number, :phone_number, avatar_attributes: [:id, :image])
	end

	def lecturer_params
		params.require(:lecturer).permit(:nip, :nid, :full_name, :address, :born, :level, :front_title, :back_title, avatar_attributes: [:id, :image])
	end

	def account_params
		params.require(:user).permit(:email, :username)
	end

	def password_params
		params.require(:user).permit(:password, :password_confirmation)
	end

end
