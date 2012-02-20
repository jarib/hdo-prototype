module HDO
  module Model
    class Issue < ActiveRecord::Base
      has_and_belongs_to_many :topics, :class_name => "HDO::Model::Topic"
    end
  end
end

