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
end
