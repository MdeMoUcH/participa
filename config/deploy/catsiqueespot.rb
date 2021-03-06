role :app, %w{capistrano@catsiqueespot.masmadrid.org}
role :web, %w{capistrano@catsiqueespot.masmadrid.org}
role :db,  %w{capistrano@catsiqueespot.masmadrid.org}

set :rvm_ruby_version, '2.4.2'
set :repo_url, 'git@github.com:insomniaproyectos/participa.git'
set :branch, :catsiqueespot
set :rails_env, :production
set :deploy_to, '/var/www/participa.masmadrid.org'

after 'deploy:publishing', 'deploy:restart'
namespace :deploy do
  task :start do
    on roles(:app) do
      execute "/etc/init.d/unicorn_production start"
      execute "sudo /etc/init.d/god start"
    end
  end
  task :stop do
    on roles(:app) do
      execute "/etc/init.d/unicorn_production stop"
      execute "sudo /etc/init.d/god stop"
    end
  end
  task :restart do
    on roles(:app) do
      execute "/etc/init.d/unicorn_production restart"
      execute "sudo /etc/init.d/god restart"
    end
  end
end
