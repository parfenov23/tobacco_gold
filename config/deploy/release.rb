set :application, 'tobacco_gold'
set :user, 'tobacco_gold'
server '185.60.133.52', user: fetch(:user), roles: %w(web app db)
set :rails_env, 'production'
set :branch, :master

set :deploy_to, "/home/#{ fetch :user }/htdocs"
set :unicorn_pid, "#{ fetch :deploy_to}/shared/pids/unicorn.pid"
set :unicorn_config_path, "#{ fetch :deploy_to }/current/config/unicorn/release.rb"