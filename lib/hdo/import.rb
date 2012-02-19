require 'hdo/db'
require 'hdo/import/committee'
require 'hdo/import/issue'
require 'hdo/import/party'
require 'hdo/import/representative'
require 'hdo/import/topic'

module HDO
  module Import
    EXPORT_DIR         = File.expand_path("../../../folketingparser/rawdata/data.stortinget.no/eksport", __FILE__)
    DEFAULT_SESSION_ID = "2011-2012"

    def self.all
      parties
      committees
      topics
      representatives
      issues
    end

    def self.parties
      progress("importing parties") {
        parties = Party.from_xml(File.join(EXPORT_DIR, "partier/index.html?sesjonid=#{DEFAULT_SESSION_ID}"))
        parties.each do |party|
          Model::Party.create(:name => party.name, :import_id => party.id)
        end
      }
    end

    def self.committees
      progress("importing committees") {
        coms = Committee.from_xml(File.join(EXPORT_DIR, "komiteer/index.html?SesjonId=#{DEFAULT_SESSION_ID}"))
        coms.each do |com|
          Model::Committee.create(:name => com.name, :import_id => com.id)
        end
      }
    end

    def self.issues
      progress("importing issues") {
        issues = Issue.from_xml(File.join(EXPORT_DIR, "saker/index.html?sesjonid=#{DEFAULT_SESSION_ID}"))
        issues.each do |i|
          topics = i.topics.map { |e| Model::Topic.find_by_import_id(e.id) or raise "#{e.id}/#{e.name} not found" }

          Model::Issue.create(
            :import_id      => i.id,
            :short_title    => i.short_title,
            :title          => i.title,
            :last_update    => i.last_update,
            :type           => i.type,
            :document_group => i.document_group,
            :reference      => i.reference,
            :topics         => topics
          )
        end
      }
    end

    def self.representatives
      progress("importing representatives") {
        reps = Representative.from_xml(File.join(EXPORT_DIR, "dagensrepresentanter/index.html"))
        reps.each do |rep|
          party = Model::Party.find_by_name(rep.party)
          committees = rep.committees.map { |id| Model::Committee.find_by_import_id(id) }
          Model::Representative.create(:first_name => rep.first_name, :last_name => rep.last_name, :county => rep.county, :party => party, :committees => committees)
        end
      }
    end

    def self.topics
      progress("importing topics") {
        topics = Topic.from_xml(File.join(EXPORT_DIR, "emner/index.html"))
        topics.each do |t|
          parent = Model::Topic.create(:import_id => t.id, :main => t.main_topic?, :name => t.name)
          t.sub_topics.each do |sub|
            parent.children.create(:import_id => sub.id, :main => sub.main_topic?, :name => sub.name)
          end
          parent.save
        end
      }
    end

    def self.progress(msg)
      start = Time.now
      print "#{msg}..."
      yield
      puts "done. [#{Time.now - start}s]"
    end
  end
end