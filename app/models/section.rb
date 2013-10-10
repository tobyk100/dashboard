class Section < ActiveRecord::Base
  belongs_to :user
  has_many :students, through: :followers, source: :student_user
end
