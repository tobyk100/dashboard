module LevelsHelper
  def build_tagged_url(script_level, user)
    callback_url = ["callback_url", milestone_url(user_id: user, script_level_id: script_level)]
    level = script_level.level
    if level.level_url
      level.level_url
    else
      uri = URI.parse(level.game.base_url)
      new_query_ar = uri.query ? URI.decode_www_form(uri.query) : []
      new_query_ar << callback_url
      new_query_ar << ["level", level.level_num || 1]
      new_query_ar << ["lang", user.try(:language) || 'en']
      new_query_ar << ["menu", 'false']
      uri.query = URI.encode_www_form(new_query_ar)
      uri.to_s
    end
  end

  def build_level_url(level, user)
    if level.level_url
      level.level_url
    else
      uri = URI.parse(level.game.base_url)
      new_query_ar = uri.query ? URI.decode_www_form(uri.query) : []
      new_query_ar << ["level", level.level_num || 1]
      new_query_ar << ["lang", user.try(:language) || 'en']
      new_query_ar << ["menu", 'false']
      uri.query = URI.encode_www_form(new_query_ar)
      uri.to_s
    end
  end

  def next_level_url(sl)
    next_level = ScriptLevel.find_by_script_id_and_chapter(sl.script, sl.chapter + 1) || sl.script.script_levels.first
    script_level_path(sl.script, next_level)
  end
end
