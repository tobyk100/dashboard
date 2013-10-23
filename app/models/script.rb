class Script < ActiveRecord::Base
  has_many :levels, through: :script_levels
  has_many :script_levels
  belongs_to :wrapup_video, foreign_key: 'wrapup_video_id', class_name: 'Video'
  
  def script_levels_from_game(game_index)
    script_levels.includes({ level: :game }, :script).order(:chapter).where(['games.id = :index', { :index => game_index}]).references(:game)
  end
  
  def multiple_games?
    # simplified check to see if we are in a script that has only one game (stage)
    levels.first.game_id != levels.last.game_id
  end
end
