namespace :deploy do
	desc "Generate nginx configuration"
	task :nginx_template do
		STDOUT.puts "Location nginx configuration for this app ? (default: (/etc/nginx/conf.d)) "
		input = STDIN.gets.strip
		location = input.nil? || input.blank? ? "/etc/nginx/conf.d" : input
		erb = File.read("#{Rails.root}/lib/tasks/templates/nginx.conf.erb")
		res = ERB.new(erb).result(binding)
		puts "placing nginx conf to #{location}"
		File.open("#{location}/simps", 'w+') {|f| f.write(res)}
	end

	desc "Generate init script on /etc/init.d"
	task :init_script do
		erb = File.read("#{Rails.root}/lib/tasks/templates/app_init.sh.erb")
		res = ERB.new(erb).result(binding)
		puts "placing init script to /etc/init.d"
		File.open("/etc/init.d/simps", 'w+') {|f| f.write(res)}
	end
end
