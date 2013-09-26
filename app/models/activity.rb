class Activity < ActiveRecord::Base
  MINIMUM_PASS_RESULT = 10
  BEST_PASS_RESULT = 100

  belongs_to :level
  belongs_to :user
end
