class Game < ActiveRecord::Base
  has_many :levels
  belongs_to :intro_video, foreign_key: 'intro_video_id', class_name: 'Video'

  def video?
    self.name == 'Video'
  end
end
