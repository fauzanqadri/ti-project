require "net/http"

module ActAsNotify

	module UriHelper

		def ws_uri
			URI.parse(ENV["WS_URI"])
		end

		def split_uri
			URI.split(ws_uri.to_s)
		end

		def mount_uri_path
			split_uri[5]
		end

		def hierarchical_part_url
			"#{ws_uri}/#{split_uri[5]}.js"
		end

	end

	class PushNotification
		include UriHelper
	
		attr_accessor :data, :channel

		def initialize params = {}
			@data ||= params[:data]
			@channel ||= params[:channel]
		end
					
		def message
			{ channel: channel, data: data, ext: {:auth_token => ENV["FAYE_TOKEN"]} }
		end
		
		def broadcast
			Net::HTTP.post_form(ws_uri, :message => message.to_json)
		end

	end

	class PushNotificationWorker

		include Sidekiq::Worker

		sidekiq_options :queue => :default, :retry => 5

		def perform channel, data = {}
			notify = PushNotification.new data: data, channel: channel
			notify.broadcast
		end

	end

	module ControllerAdditions
		include UriHelper


		module ClassMethods

			def broadcast(channel, data = {})
				PushNotificationWorker.perform_async(channel, data)
			end

		end

		def self.broadcast(channel, data = {})
			PushNotificationWorker.perform_async(channel, data)
		end

    def self.included(base)
      base.extend(ClassMethods)
      base.helper_method :ws_uri, :hierarchical_part_url, :mount_uri_path
    end

	end

	module ModelAdditions
		extend ActiveSupport::Concern

		module ClassMethods

			def broadcast(channel, data = {})
				PushNotificationWorker.perform_async(channel, data)
			end

		end

		def broadcast(channel, data = {})
			PushNotificationWorker.perform_async(channel, data)
		end
	end

end

ActiveRecord::Base.send(:include, ActAsNotify::ModelAdditions)

if defined? ActionController::Base
  ActionController::Base.class_eval do
    include ActAsNotify::ControllerAdditions
  end
end

