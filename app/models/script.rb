class Script < ActiveRecord::Base
  has_many :levels, through: :script_levels
end
