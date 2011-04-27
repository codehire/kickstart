# rvm
RUBIES = %w(ree-1.8.7 ruby-1.9.2)
YESNO_PROMPT = " (y/n):"
gemset = app_name

ruby = ask("Which version of ruby will you be using? [#{RUBIES.join(', ')}]:") until RUBIES.include?(ruby)

create_file ".rvmrc", "rvm use #{ruby}@#{gemset}"

# gems

%w(jquery-rails will_paginate devise cancan simple_navigation flag_shih_tzu tzinfo).each do |gem_name| 
  gem gem_name
end

gem 'ruby-debug19', :require => 'ruby-debug', :group => [:development, :test]

%w(less factory_girl factory_girl_rails forgery).each do |gem_name| 
  gem gem_name, :group => [:development, :test]
end

%w(cover_me redgreen mocha timecop rspec-rails cucumber-rails capybara akephalos database_cleaner launchy).each do |gem_name| 
  gem gem_name, :group => [:test]
end

%w(newrelic_rpm whereuat).each do |gem_name| 
  gem gem_name, :group => [:development, :production]
end


DATABASES = %w(mysql pg both)
db = ask("Which database(s) will you be using for development? [#{DATABASES.join(', ')}]") until DATABASES.include?(db)
case db
when 'mysql'
  gem 'mysql'
when 'pg'
  gem 'postgres-pr'
when 'both'
  gem 'postgres-pr'
  gem 'mysql'
end

DEPLOYMENT = %w(heroku engineyard capistrano)
deploy_type = ask("How will this app be deployed? [#{DEPLOYMENT.join(', ')}]") until DEPLOYMENT.include?(deploy_type)
gem deploy_type

if yes? %Q{Would you like to use the Inherited Resources gem?
  (see: https://github.com/josevalim/inherited_resources for details)#{YESNO_PROMPT}}
  gem 'inherited_resources'
end

if yes? %Q{Would you like to use friendly instance IDs?
  (eg /users/fred/blogs/first-post instead of /users/1/blogs/1)#{YESNO_PROMPT}}
  gem 'friendly_id'
end

if yes? %Q{Do you need a state machine?#{YESNO_PROMPT}}
  gem 'state_machine'
end

if yes? %Q{Do you need to upload files?#{YESNO_PROMPT}}
  gem 'carrierwave'
  gem 'mini_magick'
end

if yes? %Q{Do you need to manage user preferences?#{YESNO_PROMPT}}
  gem 'preferences'
end

if yes? %Q{Do you need to allow user comments?#{YESNO_PROMPT}}
  gem 'acts_as_commentable'
  
end


