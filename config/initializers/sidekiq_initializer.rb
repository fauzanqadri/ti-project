sidekiq_hash = {url: ENV["REDIS_URL"]}
sidekiq_hash.merge!({namespace: ENV["REDIS_NAMESPACE"]}) unless ENV["REDIS_NAMESPACE"].nil?

Sidekiq.configure_server do |config|
  config.redis = sidekiq_hash
end

Sidekiq.configure_client do |config|
  config.redis = sidekiq_hash
end