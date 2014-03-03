web: bundle exec unicorn -E $RAILS_ENV -c config/unicorn.rb -D
unicorn: tail -f log/unicorn.log
bullet: tail -f log/bullet.log
activerecord_log: tail -f log/active_record.log