server "192.168.0.151", :app, :web, :db, :primary => true
set :rails_env, "staging"
set :user, 'hutbindada'
set :branch, :master
set :deploy_to, "/home/hutbindada/www/telegeam_mail_bot"

default_run_options[:pty] = true
set :default_environment, {
  'PATH' => "/home/hutbindada/.rbenv/shims:/home/hutbindada/.rbenv/bin:$PATH"
}