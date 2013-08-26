class ScriptLevel < ActiveRecord::Base
  belongs_to :level
  belongs_to :script

  # this is
  attr_accessor :user_level

  ScriptLevel::NEXT = 'next'
end
