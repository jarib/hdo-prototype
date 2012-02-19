$:.unshift File.expand_path("../lib", __FILE__)

require 'sinatra'
require 'nokogiri'
require 'json'
require 'party'
require 'representative'
require 'topic'
require 'issue'

set :public_folder, File.expand_path("../public", __FILE__)
set :export_folder, File.expand_path("../folketingparser/rawdata/data.stortinget.no/eksport", __FILE__)
set :cache, {}

get "/" do
  erb :index
end

get "/parties" do
  @parties = settings.cache[:parties] ||= Party.from_xml(File.join(settings.export_folder, "partier/index.html\?sesjonid=2011-2012"))

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
  @issues = settings.cache[:issues] ||= Issue.from_xml(File.join(settings.export_folder, "saker/index.html?sesjonid=2011-2012"))
  @issues = @issues.sort_by { |e| e.id }
  erb :issues
end