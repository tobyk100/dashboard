class Follower < ActiveRecord::Base
  belongs_to :user
  belongs_to :student_user, foreign_key: "student_user_id", class_name: User
  belongs_to :section
end
