class TeacherPrize < ActiveRecord::Base
  belongs_to :prize_provider
  belongs_to :user
end
