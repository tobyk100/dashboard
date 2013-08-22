class Script < ActiveRecord::Base
  has_many :levels, through: :script_levels
  has_many :script_levels
end
