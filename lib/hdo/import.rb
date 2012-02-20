require 'hdo/db'
require 'hdo/import/committee'
require 'hdo/import/issue'
require 'hdo/import/party'
require 'hdo/import/representative'
require 'hdo/import/topic'
require 'hdo/import/vote'

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
      # votes
    end

    def self.parties
      progress("importing parties") {
        parties = Party.from_xml path_for("partier/index.html?sesjonid=#{DEFAULT_SESSION_ID}")
        parties.each do |party|
          Model::Party.create(:name => party.name, :external_id => party.id)
        end
      }
    end

    def self.committees
      progress("importing committees") {
        coms = Committee.from_xml path_for("komiteer/index.html?SesjonId=#{DEFAULT_SESSION_ID}")
        coms.each do |com|
          Model::Committee.create(:name => com.name, :external_id => com.id)
        end
      }
    end

    def self.issues
      progress("importing issues") {
        issues = Issue.from_xml path_for("saker/index.html?sesjonid=#{DEFAULT_SESSION_ID}")
        issues.each do |i|
          topics = i.topics.map { |e| Model::Topic.find_by_external_id(e.id) or raise "#{e.id}/#{e.name} not found" }

          Model::Issue.create(
            :external_id      => i.id,
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
        reps = Representative.from_xml path_for("dagensrepresentanter/index.html")
        reps.each do |rep|
          party = Model::Party.find_by_name(rep.party)
          committees = rep.committees.map { |id| Model::Committee.find_by_external_id(id) }
          Model::Representative.create(
            :first_name => rep.first_name,
            :last_name  => rep.last_name,
            :county     => rep.county,
            :party      => party,
            :committees => committees
          )
        end
      }
    end

    def self.topics
      progress("importing topics") {
        topics = Topic.from_xml path_for("emner/index.html")
        topics.each do |t|
          parent = Model::Topic.create(:external_id => t.id, :main => t.main_topic?, :name => t.name)
          t.sub_topics.each do |sub|
            parent.children.create(:external_id => sub.id, :main => sub.main_topic?, :name => sub.name)
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

    def self.path_for(relative)
      File.join(EXPORT_DIR, relative)
    end
  end
end