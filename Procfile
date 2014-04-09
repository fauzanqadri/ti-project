web: bundle exec unicorn -E $RAILS_ENV -c config/unicorn.rb
websocket: rackup faye.ru -s puma -E production
sidekiq: bundle exec sidekiq -C config/sidekiq.yml
log: tail -f log/development.log