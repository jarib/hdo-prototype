require 'hdo/db'

module HDO
  class App < Sinatra::Base

    set :public_folder, File.expand_path("../public", __FILE__)
    set :cache, {}

    configure do
    end

    get "/" do
      erb :index
    end

    get "/parties" do
      @parties = settings.cache[:parties] ||= Model::Party.all
      erb :parties
    end

    get "/representatives" do
      @representatives = settings.cache[:representatives] ||= Model::Representative.order(:last_name)
      erb :representatives
    end

    get "/topics" do
      @topics = settings.cache[:topics] ||= Model::Topic.order(:import_id)
      erb :topics
    end

    get "/issues" do
      @issues = settings.cache[:issues] ||= Model::Issue.order(:import_id)
      erb :issues
    end

    get "/committees" do
      @committees = settings.cache[:committees] ||= Model::Committee.order(:import_id)
      erb :committees
    end

    get "/cache/reset" do
      if params[:key]
        settings.cache.delete params[:key].to_sym
      else
        settings.cache.clear
      end
    end

  end
end