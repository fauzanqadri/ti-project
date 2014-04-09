web: bundle exec unicorn -E $RAILS_ENV -c $UNICORN_CONFIG
websocket: rackup faye.ru -s puma -E production
sidekiq: bundle exec sidekiq -C $SIDEKIQ_CONFIG
log: tail -f log/development.log