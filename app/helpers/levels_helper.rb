module LevelsHelper
  def build_tagged_url(level, user)
    uri =  URI.parse(level.level_url)
    new_query_ar = URI.decode_www_form(uri.query) << ["callback_url", root_url(user)]
    uri.query = URI.encode_www_form(new_query_ar)
    uri.to_s
  end
end
