class Script < ActiveRecord::Base
  has_many :levels, through: :script_levels
  has_many :script_levels
  belongs_to :wrapup_video, foreign_key: 'wrapup_video_id', class_name: 'Video'

  TWENTY_HOUR_ID = 2
  HOC_ID = 2

  HOC_SCRIPT = Script.includes(:script_levels).find(HOC_ID)
  TWENTY_HOUR_SCRIPT = Script.includes(:script_levels).first

  def script_levels_from_game(game_index)
    script_levels.includes({ level: :game }, :script).order(:chapter).where(['games.id = :index', { :index => game_index}]).references(:game)
  end
  
  def multiple_games?
    # simplified check to see if we are in a script that has only one game (stage)
    levels.first.game_id != levels.last.game_id
  end

  def twenty_hour?
    self.id == TWENTY_HOUR_ID
  end

  def hoc?
    self.id == HOC_ID
  end

  def find_script_level(level_id)
    self.script_levels.detect { |sl| sl.level_id == level_id }
  end
end
