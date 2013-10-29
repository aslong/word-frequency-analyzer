set :application, "word_frequency_analyzer"
set :repository, "git@github.com:aslong/word-frequency-analyzer.git"
set :branch, "master"
set :deploy_to, "/home/deployer/#{application}"

set :user, 'deployer'
set :group, 'deployer'
set :runner, 'deployer'
set :keep_releases, 5

set :scm, :git
set :deploy_via, :remote_cache
ssh_options[:forward_agent] = true

# multistage
set :default_stage, "staging"
set :stages, %w(prod staging)
set :stage_dir, "deploy"
require 'capistrano/ext/multistage'

task :log do
  # nada
end

task :start do
end

task :stop do
end

task :restart do
end

namespace :word_frequency_analyzer do

  task :start, :on_error => :continue do
    sudo "start word-frequency-analyzer"
  end

  task :stop, :on_error => :continue do
    sudo "stop word-frequency-analyzer"
  end

  task :restart, :on_error => :continue do
    sudo "restart word-frequency-analyzer"
  end

  task :log do
    run "cd /home/deployer/word_frequency_analyzer/shared/log/ && tail -F word_frequency_analyzer.log"
  end

  task :compile do
    run "cd #{current_release} && grunt clean && grunt coffee:compile"
  end

  task :npm_full_install do
    run "rm -r #{current_release}/node_modules || cd #{current_release} && cd #{current_release} && npm install"
    run "cp -rf #{current_release}/node_modules  #{deploy_to}/shared/"
  end

  task :node_module_copy do
    run "cp -r #{deploy_to}/shared/node_modules #{current_release}/."
  end

  task :setuplogs do
    run "mkdir -p #{deploy_to}/shared/log"
    run "touch #{deploy_to}/shared/log/word-frequency-analyzer.log"
    put File.read("deploy/files/word-frequency-analyzer.logrotate"), "#{deploy_to}/shared/word-frequency-analyzer.logrotate"
    sudo "cp #{deploy_to}/shared/word-frequency-analyzer.logrotate /etc/logrotate.d/word-frequency-analyzer"
    sudo "[ ! -f /etc/cron.hourly/logrotate ] && sudo cp /etc/cron.daily/logrotate /etc/cron.hourly/logrotate || echo 'Already setup for hourly log rotate'"
    sudo "[ -f /etc/cron.hourly/logrotate ] && sudo rm /etc/cron.daily/logrotate || echo 'Hourly logrotate already moved'"
    sudo "logrotate /etc/logrotate.conf"
  end

  task :install_init_files do
    run "echo \"Installing #{application}'s /etc/init/*.conf files\""
    sudo "cp #{current_release}/deploy/files/*.conf /etc/init/."
  end
end

before 'log', 'word_frequency_analyzer:log'
before 'restart', 'word_frequency_analyzer:restart'
before 'start', 'word_frequency_analyzer:start'
before 'stop', 'word_frequency_analyzer:stop'

after 'deploy', 'word_frequency_analyzer:node_module_copy', 'word_frequency_analyzer:compile', 'deploy:cleanup'
after 'deploy:cold', 'word_frequency_analyzer:setuplogs', 'word_frequency_analyzer:install_init_files', 'word_frequency_analyzer:npm_full_install'
