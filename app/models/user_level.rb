class UserLevel < ActiveRecord::Base
  belongs_to :user
  belongs_to :level

  scope :for_list, { include: [ { level: :game } ] }
end
