class ScriptLevel < ActiveRecord::Base
  belongs_to :level
  belongs_to :script

  # this is
  attr_accessor :user_level

  scope :for_list, { include: [ { level: :game }, :script ], order: :chapter }
end
