#working_directory ENV["UNICORN_WORKING_DIR"]
#pid ENV["UNICORN_PID"]
stderr_path ENV["UNICORN_STDERR"]
stdout_path ENV["UNICORN_STDOUT"]
# working_directory "/Volumes/Projects/Ruby/rails/ti-project"
# pid "/Volumes/Projects/Ruby/rails/ti-project/tmp/pids/unicorn.pid"
# stderr_path "/Volumes/Projects/Ruby/rails/ti-project/log/unicorn.log"
# stdout_path "/Volumes/Projects/Ruby/rails/ti-project/log/unicorn.log"

listen "/tmp/unicorn.simps.sock", :backlog => 64

if ENV["RAILS_ENV"] == "production"
	worker_processes 4
else
	worker_processes 2
end

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