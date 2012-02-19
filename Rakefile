$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require 'bundler/setup'


namespace :db do
  task :import do
    rm_f 'db.sqlite'
    touch 'db.sqlite'

    require 'hdo'
    require 'hdo/import'
    HDO::Import.all
  end
end