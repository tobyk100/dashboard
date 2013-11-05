class ScriptLevel < ActiveRecord::Base
  belongs_to :level
  belongs_to :script

  NEXT = 'next'

  # this is
  attr_accessor :user_level

  def next_level
    ScriptLevel.find_by_script_id_and_chapter(self.script, self.chapter + 1)
  end

  def previous_level
    ScriptLevel.find_by_script_id_and_chapter(self.script, self.chapter - 1)
  end
end
