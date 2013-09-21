module LevelsHelper
  def build_query_params(script_level, user)
    level = script_level.level
    new_query_ar = {"level" => level.level_num || 1,
                    "lang" => user.try(:language) || 'en',
                    "menu" => 'false',
                    "callback_url" => milestone_url(user_id: user.try(:id) || 0, script_level_id: script_level)}
  end

  def build_script_level_path(script_level)
    query_params = build_query_params(script_level, current_user)
    script_level_path(script_level.script, script_level.level, query_params)
  end
end
