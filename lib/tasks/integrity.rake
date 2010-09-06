require 'fileutils'
namespace :integrity do
  
  file 'config/database.yml' do
      # set up database.yml
      FileUtils.cp('config/database.yml.ci', 'config/database.yml')
  end
  
  
  desc 'Integrity CI task'
  task :build => ['config/database.yml', 'db:schema:load', :environment]
end