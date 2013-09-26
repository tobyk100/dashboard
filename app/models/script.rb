class Script < ActiveRecord::Base
  has_many :levels, through: :script_levels
  has_many :script_levels
  belongs_to :wrapup_video, foreign_key: 'wrapup_video_id', class_name: 'Video'
end
