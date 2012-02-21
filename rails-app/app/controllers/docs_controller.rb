class DocsController < ApplicationController
  def index
    load 'hdo/import.rb' # figure out how to autoload this

    @import_types = [
      Hdo::Import::Representative,
      Hdo::Import::Party,
      Hdo::Import::Issue,
      Hdo::Import::Topic,
      Hdo::Import::Committee,
    ]
  end
end
