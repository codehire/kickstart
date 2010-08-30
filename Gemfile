source 'http://rubygems.org'
gem "rails", "~> 2.3.8"

# Postgres support
gem 'pg'

# These are "core" gems we always use
gem 'authlogic'
gem 'searchlogic'
gem 'navigasmic'
gem 'will_paginate'
gem 'json_pure'
gem 'capistrano'

# State machine support
gem 'aasm'

# jQuery
gem 'jrails'

# Textile user content formatting
gem 'RedCloth', :require => 'redcloth' # Must require explicitly as Bundler can't infer the lib to require

# Paperclip for attachments, plus DJ for async resizes
# http://jstorimer.com/ruby/2010/01/30/delayed-paperclip.html
gem 'paperclip'
gem 'delayed_job'
gem 'delayed_paperclip'

group :test, :cucumber do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'spork'
  gem 'launchy'    # So you can do Then show me the page
  gem 'cucumber'
  gem 'cucumber-rails'
  gem 'pickle'
  gem 'factory_girl'
  gem 'faker'
  gem 'shoulda'
end