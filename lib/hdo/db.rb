require 'active_record'
require 'sqlite3'
require 'acts_as_tree'

ActiveRecord::Base.establish_connection(
  :adapter  => "sqlite3",
  :database => File.expand_path("../../../db.sqlite", __FILE__)
)

require 'hdo/model/party'
require 'hdo/model/committee'
require 'hdo/model/issue'
require 'hdo/model/representative'
require 'hdo/model/topic'

unless HDO::Model::Party.table_exists?
  ActiveRecord::Schema.define do
    create_table :parties do |t|
      t.string :import_id
      t.string :name
    end

    create_table :committees do |t|
      t.string :import_id
      t.string :name
    end

    create_table :issues do |t|
      t.integer :import_id
      t.string  :short_title
      t.string  :title
      t.time    :last_update
      t.string  :type
      t.string  :document_group
      t.string  :reference
    end

    create_table :representatives do |t|
      t.string :import_id
      t.integer :party_id
      t.string :first_name
      t.string :last_name
      t.string :county # county_id
      t.string :party # party_id
      t.string :committee # committee_id
      t.string :deputy_for # representative_id
    end

    create_table :topics do |t|
      t.integer :import_id
      t.integer :parent_id
      t.boolean :main
      t.string :name
    end

    create_table :representatives_parties, :id => false do |t|
      t.references :representative, :party
    end
    add_index :representatives_parties, [:representative_id, :party_id]

    create_table :committees_representatives, :id => false do |t|
      t.references :committee, :representative
    end
    add_index :committees_representatives, [:committee_id, :representative_id], :name => "coms_reps" # avoid index name limit

    create_table :issues_topics, :id => false do |t|
      t.references :issue, :topic
    end
    add_index :issues_topics, [:issue_id, :topic_id]

  end
end