module HDO
  module Model

    class Representative < ActiveRecord::Base
      belongs_to :party, :class_name => "HDO::Model::Party"
      has_and_belongs_to_many :committees, :class_name => "HDO::Model::Committee"

      def name
        "#{last_name}, #{first_name}"
      end
    end

  end
end

