if ENV["RAILS_ENV"] == "production"
	require "paperclip/storage/ftp"
	hosts = [
		{
			host: ENV["PP_FTP_HOST"], 
			user: ENV["PP_FTP_USER"], 
			password: ENV["PP_FTP_PASSWORD"], 
			port: ENV["PP_FTP_PORT"]
		}
	]
	Paperclip::Attachment.default_options[:storage] = :ftp
	Paperclip::Attachment.default_options[:ftp_servers] = hosts
	Paperclip::Attachment.default_options[:ftp_connect_timeout] = 120
	Paperclip::Attachment.default_options[:ftp_ignore_failing_connections] = true
end