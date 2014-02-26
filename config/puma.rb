pidfile 'tmp/pids/puma.pid'
state_path 'tmp/pids/puma.state'

threads 8, 32
bind "unix:///tmp/puma.sock"

# activate_control_app 'unix:///tmp/sockets/pumactl.sock'
workers 3
preload_app!
on_worker_boot do
	ActiveRecord::Base.connection_pool.disconnect!
  ActiveSupport.on_load(:active_record) do
  	if Rails.application.config.database_configuration
  		config = Rails.application.config.database_configuration[Rails.env]
  		ActiveRecord::Base.establish_connection(config)
  	end
  end
end