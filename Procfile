web: bundle exec unicorn -E $RAILS_ENV -c config/unicorn.rb
bullet: tail -f log/bullet.log
sidekiq: bundle exec sidekiq -C config/sidekiq.yml