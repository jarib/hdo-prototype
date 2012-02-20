module HDO
  module Model
    class Topic < ActiveRecord::Base
      acts_as_tree
      has_and_belongs_to_many :issues, :class_name => "HDO::Model::Issues"
    end
  end
end

