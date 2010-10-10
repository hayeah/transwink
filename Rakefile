# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake'

Twink::Application.load_tasks

namespace :translink do
  task :update => :environment do
    Route.populate
  end
end
