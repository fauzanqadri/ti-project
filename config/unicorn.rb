working_directory "/Volumes/Projects/Ruby/rails/ti-project"
pid "/Volumes/Projects/Ruby/rails/ti-project/tmp/pids/unicorn.pid"
stderr_path "/Volumes/Projects/Ruby/rails/ti-project/log/unicorn.log"
stdout_path "/Volumes/Projects/Ruby/rails/ti-project/log/unicorn.log"

listen "/tmp/unicorn.ti_project.sock", :backlog => 64
worker_processes 4
timeout 30

preload_app true

GC.respond_to?(:copy_on_write_friendly=) and
	GC.copy_on_write_friendly = true

check_client_connection false

before_fork do |server, worker|
	defined?(ActiveRecord::Base) and
		ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
	defined?(ActiveRecord::Base) and
		ActiveRecord::Base.establish_connection
end