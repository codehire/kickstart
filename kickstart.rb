rvm_lib_path = "#{`echo $rvm_path`.strip}/lib"
$LOAD_PATH.unshift(rvm_lib_path) unless $LOAD_PATH.include?(rvm_lib_path)
require 'rvm'

ruby = 'ruby-1.9.2'
db = 'pg'
deploy_type = 'heroku'

def self.after_bundle_install(&block)
  if block_given?
    @procs_to_run ||= []
    @procs_to_run << Proc.new(&block)
  else
    @procs_to_run.each do |p|
      p.call
    end
  end
end

# rvm
RUBIES = %w(ree-1.8.7 ruby-1.9.2)
YESNO_PROMPT = " (y/n):"
gemset = app_name

ruby = ask("Which version of ruby will you be using? [#{RUBIES.join(', ')}]:") until RUBIES.include?(ruby)

create_file ".rvmrc", "rvm use #{ruby}@#{gemset} --create"

# gems
# Remove selected DB gem
gsub_file 'Gemfile', /^gem '(pg|mysql)'.*$/, ''

# Strip comments and blank lines
gsub_file 'Gemfile', /^(# .*)?\n/, '' 

%w(jquery-rails will_paginate devise cancan simple-navigation tzinfo).each do |gem_name| 
  gem gem_name
end

after_bundle_install {
  inject_into_file 'config/application.rb', :after => "config.filter_parameters += [:password]" do
<<-END

    config.generators do |g|
      g.stylesheets false
      g.test_framework :rspec
      g.fixture_replacement :factory_girl, :dir => 'spec/factories'
    end
END
  end
  
  # jquery-rails
  flags = " --ui" if ask("Do you want jQuery UI?#{YESNO_PROMPT}")
  generate("jquery:install#{flags}")
  
  # cancan
  generate("cancan:ability")
  
  # devise
  generate("devise:install")
  model_name = ask("What would you like the user model to be called? [user]")
  model_name = "user" if model_name.blank?
  generate("devise", model_name)
  
  # simple navigation
  generate("navigation_config")
  
  # flag_shih_tzu
  plugin('flag_shih_tzu', :git => 'git://github.com/xing/flag_shih_tzu.git')
}

if ruby =~ /1\.9/
  gem 'ruby-debug19', :require => 'ruby-debug', :group => [:development, :test]
else
  gem 'ruby-debug', :group => [:development, :test]
end

# Append these group definitions for a much tidier Gemfile :)
append_file 'Gemfile', %Q{
group :development, :test do
  gem 'less'

  # can be useful in dev for dummy data
  gem 'factory_girl'
  gem 'factory_girl_rails'
  gem 'forgery'
end

group :test do
  gem 'cover_me'
  gem 'timecop'
  gem 'rspec-rails'
  gem 'cucumber-rails'
  gem 'capybara'
  gem 'akephalos'
  gem 'database_cleaner'
  gem 'launchy'
end

group :development, :production do
  gem 'newrelic_rpm'
  gem 'whereuat'
end
}

after_bundle_install {
  generate('cucumber:install', '--rspec', '--capybara')
  generate('rspec:install')
  generate('forgery')
  plugin('more', :git => 'git://github.com/cloudhead/more.git')
}

DATABASES = %w(mysql pg both)
db = ask("Which database(s) will you be using for development? [#{DATABASES.join(', ')}]") until DATABASES.include?(db)
case db
when 'mysql'
  gem 'mysql'
when 'pg'
  gem 'pg'
when 'both'
  gem 'pg'
  gem 'mysql'
end


DEPLOYMENT = %w(heroku engineyard capistrano)
deploy_type = ask("How will this app be deployed? [#{DEPLOYMENT.join(', ')}]") until DEPLOYMENT.include?(deploy_type)
gem deploy_type

if yes? %Q{Would you like to use the Inherited Resources gem?
  (see: https://github.com/josevalim/inherited_resources for details)#{YESNO_PROMPT}}
  gem 'inherited_resources'
  after_bundle_install { 
    inject_into_class "app/controllers/application_controller.rb", 'ApplicationController', do
<<-END
  # Uncomment the following to use inherited resources globally
  # inherit_resources
END
    end
  }
end

if yes? %Q{Would you like to use friendly instance IDs?
  (eg /users/fred/blogs/first-post instead of /users/1/blogs/1)#{YESNO_PROMPT}}
  gem 'friendly_id'
  after_bundle_install { generate('friendly_id')}
end

if yes? %Q{Do you need a state machine?#{YESNO_PROMPT}}
  gem 'state_machine'
end

if yes? %Q{Do you need to upload files?#{YESNO_PROMPT}}
  gem 'carrierwave'
  gem 'mini_magick'
  after_bundle_install {
    if ask("Do you want to generate an uploader now?#{YESNO_PROMPT}")
      model_name = ask("What would you like the uploader to be called? [file]")
      model_name = "file" if model_name.blank?
      generate("uploader", model_name)
    end
  }
end

if yes? %Q{Do you need to manage user preferences?#{YESNO_PROMPT}}
  gem 'preferences'
end

if yes? %Q{Do you need to allow user comments?#{YESNO_PROMPT}}
  gem 'acts_as_commentable', :git => 'https://github.com/jackdempsey/acts_as_commentable.git'
  after_bundle_install { 
    model_name = ask("What would you like the comment model to be called? [comment]")
    model_name = "comment" if model_name.blank?
    generate("comment", model_name)
  }
end

say "Finished configuring the Gemfile. Installing...", Thor::Shell::Color::YELLOW

@env = RVM::Environment.new(ruby)
@env.gemset_create(gemset)
say "Now using gemset #{gemset}", Thor::Shell::Color::YELLOW
@env.gemset_use!(gemset)
@env.system("gem", "install", "bundler")
@env.system("gem", "install", "rake")
say "Bundle installing, Please wait...", Thor::Shell::Color::GREEN
run 'bundle install'
say "Bundle install complete", Thor::Shell::Color::GREEN
after_bundle_install

# Cleanup
remove_file 'README'
remove_file 'doc/README_FOR_APP'
remove_file 'public/index.html'
remove_file 'public/images/rails.png'
run 'mv config/database.yml config/database.yml.example'

# Git ignores
append_file '.gitignore', <<-END
.DS_Store
config/database.yml
END

