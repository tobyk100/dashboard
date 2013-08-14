module LevelsHelper
  def build_tagged_url(level, user)
    if level.level_url
      uri =  URI.parse(level.level_url)
      new_query_ar = URI.decode_www_form(uri.query) << ["callback_url", root_url(user)]
      uri.query = URI.encode_www_form(new_query_ar)
      uri.to_s
    else
      uri = URI.parse(level.game.base_url)
      new_query_ar = uri.query ? URI.decode_www_form(uri.query) : []
      new_query_ar << ["callback_url", root_url(user)]
      new_query_ar << ["level", level.level_num || 1]
      new_query_ar << ["lang", user.language || 'en']
      uri.query = URI.encode_www_form(new_query_ar)
      uri.to_s
    end
  end
end
