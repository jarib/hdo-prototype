$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require 'bundler/setup'

namespace :submodule do
  desc 'Update the submodule'
  task :update do
    Dir.chdir("folketingparser") { sh "git pull origin master" }
  end
end

namespace :db do
  desc 'Re-create the database from the data.stortinget.no XML'
  task :import do
    rm_f 'db.sqlite'
    touch 'db.sqlite'

    require 'hdo'
    require 'hdo/import'
    HDO::Import.all
  end

  desc 'Refresh the submodule and re-create the DB'
  task :refresh => %w[submodule:update db:import] do
    sh "git status" # in case the submodule is updated, alert the user about the dirty tree
  end
end

