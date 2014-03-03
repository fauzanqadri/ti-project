working_directory "/vagrant"
pid "/vagrant/tmp/pids/unicorn.pid"
stderr_path "/vagrant/log/unicorn.log"
stdout_path "/vagrant/log/unicorn.log"

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