class Activity < ActiveRecord::Base
  MINIMUM_PASS_RESULT = 10

  belongs_to :level
  belongs_to :user
end
