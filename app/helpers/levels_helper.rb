module LevelsHelper
  def build_query_params(script_level, user)
    level = script_level.level
    skin = level.skin
    {"level" => level.level_num || "1_1",
     "skin" => skin}
  end

  def build_script_level_path(script_level)
    query_params = build_query_params(script_level, current_user)
    script_level_path(script_level.script, script_level.level, query_params)
  end
  def language
    user.try(:language) || 'en'
  end
  def locale
    'en_us'
  end
end
