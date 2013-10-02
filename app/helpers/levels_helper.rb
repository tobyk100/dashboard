module LevelsHelper
  def build_script_level_path(script_level)
    script_level_path(script_level.script, script_level.level)
  end

  def language
    user.try(:language) || 'en'
  end

  def locale
    'en_us'
  end
end
