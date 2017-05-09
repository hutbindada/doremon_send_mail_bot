require 'capistrano/ext/multistage'

set :keep_releases, 5
set :application, "Hutbindada Bot"
set :repository,  "git@gitlab.com:hutbindada/telegram_mail_bot.git"
set :scm, :git
set :branch, :master
set :use_sudo, false
set :default_stage, "staging"

after 'deploy:finalize_update', 'deploy:symlink_share'

namespace :deploy do
  task :build do
  end
  task :run_bot do
    run "cd #{release_path} && bundle install && RAILS_ENV=staging bundle exec ruby bot.rb"
  end
  
  desc 'Symlink share'
  task :symlink_share, roles: [:app, :db] do
    ## Link config file
    run "rm -f #{release_path}/config/config.yml"
    run "ln -nfs #{shared_path}/config/config.yml #{release_path}/config/config.yml"
    

  end
  
end
