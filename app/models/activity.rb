class Activity < ActiveRecord::Base
  belongs_to :level
  belongs_to :user
end
