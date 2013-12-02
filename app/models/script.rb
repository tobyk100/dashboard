class Script < ActiveRecord::Base
  has_many :levels, through: :script_levels
  has_many :script_levels
  belongs_to :wrapup_video, foreign_key: 'wrapup_video_id', class_name: 'Video'

  TWENTY_HOUR_ID = 1
  HOC_ID = 2

  def self.twenty_hour_script
    @@twenty_hour_script ||= Script.includes(script_levels: { level: [:game, :concepts] }).find(TWENTY_HOUR_ID)
  end

  def self.hoc_script
    @@hoc_script ||= Script.includes(script_levels: { level: [:game, :concepts] }).find(HOC_ID)
  end

  def self.get_from_cache(id)
    case id
      when TWENTY_HOUR_ID then twenty_hour_script
      when HOC_ID then hoc_script
      else Script.includes(script_levels: { level: [:game, :concepts] }).find(id)
    end
  end

  def script_levels_from_game(game_id)
    self.script_levels.select { |sl| sl.level.game_id == game_id }
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

  def self.find_twenty_hour_script
    Script.find_by_id(TWENTY_HOUR_ID)
  end

  def get_script_level_by_id(script_level_id)
    self.script_levels.select { |sl| sl.id == script_level_id }.first
  end

  def get_script_level_by_chapter(chapter)
    self.script_levels.select { |sl| sl.chapter == chapter }.first
  end
end
