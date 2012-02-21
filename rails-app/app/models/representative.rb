class Representative < ActiveRecord::Base
  def display_name
    "#{last_name}, #{first_name}"
  end
end
