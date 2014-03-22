require 'faye'
require_relative 'lib/act_as_notify/auth_server'

faye_server = Faye::RackAdapter.new(mount: '/faye', :timeout => 25)
faye_server.add_extension(ActAsNotify::AuthServer.new)
run faye_server