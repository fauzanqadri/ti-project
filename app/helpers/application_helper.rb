module ApplicationHelper
	def flash_convert key
    status = { notice: "alert-success", alert: "alert-danger"}
    status[key.to_sym]
  end

  def message_status key
  	status = { notice: "Success", alert: "Error"}
  	status[key.to_sym]
  end
  def icon_convert key
  	status = { notice: "fa-check", alert: "fa-exclamation-triangle"}
  	status[key.to_sym]
  end

  def setting_department_director_name id
    return "" if id.nil? || id.blank?
    Lecturer.find(id).to_s
  end

  def undo_link resource
    # link_name = params[:redo] == "true" ? "undo" : "redo"
    view_context.link_to("undo", revert_version_path(resource.versions.scoped.last), :method => :post)
  end
end
