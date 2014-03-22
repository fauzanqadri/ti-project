# require "act_as_notify"

module ActAsNotify
	class AuthServer
	
		def incoming(message, callback)
			if message['channel'] !~ %r{^/meta/}
				if message['ext']['auth_token'] != ENV['FAYE_TOKEN']
					message['error'] = 'Invalid authentication token'
				end
			end
			callback.call(message)
		end

		def outgoing(message, callback)
			if message['ext'] && message['ext']['auth_token']
				message['ext'] = {}
			end
			callback.call(message)
		end

	end
end