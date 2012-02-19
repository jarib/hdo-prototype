$:.unshift File.expand_path("../lib", __FILE__)

require 'sinatra'
require 'nokogiri'
require 'json'

require 'party'
require 'representative'
require 'topic'
require 'issue'
require 'committee'

set :public_folder, File.expand_path("../public", __FILE__)
set :export_folder, File.expand_path("../folketingparser/rawdata/data.stortinget.no/eksport", __FILE__)
set :default_session_id, "2011-2012"
set :cache, {}

get "/" do
  erb :index
end

get "/parties" do
  session_id = params[:session_id] || settings.default_session_id
  @parties = settings.cache[:parties] ||= Party.from_xml(File.join(settings.export_folder, "partier/index.html?sesjonid=#{session_id}"))

  erb :parties
end

get "/representatives" do
  @representatives = settings.cache[:representatives] ||= Representative.from_xml(File.join(settings.export_folder, "dagensrepresentanter/index.html"))
  @representatives = @representatives.sort_by { |e| e.last_name }

  erb :representatives
end

get "/topics" do
  @topics = settings.cache[:topics] ||= Topic.from_xml(File.join(settings.export_folder, "emner/index.html"))
  @topics = @topics.sort_by { |e| e.id }
  erb :topics
end

get "/issues" do
  session_id = params[:session_id] || settings.default_session_id
  @issues = settings.cache[:issues] ||= Issue.from_xml(File.join(settings.export_folder, "saker/index.html?sesjonid=#{session_id}"))
  @issues = @issues.sort_by { |e| e.id }
  erb :issues
end

get "/committees" do
  session_id = params[:session_id] || settings.default_session_id
  @committees = settings.cache[:committees] ||= Committee.from_xml(File.join(settings.export_folder, "komiteer/index.html?sesjonid=#{session_id}"))
  @committees = @committees.sort_by { |e| e.id }

  erb :committees
end