module HDO
  module Model
    class Party < ActiveRecord::Base
      has_many :representatives, :class_name => "HDO::Model::Representative"
    end
  end
end

