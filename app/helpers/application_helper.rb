require 'nokogiri'

module ApplicationHelper

  include LocaleHelper
  include ApplicationHelper

  def ago(from_time)
    s = distance_of_time_in_words_to_now(from_time)
    # XXX This is horribly broken for localization.
    s = s.gsub("about ", "")
    s = s.gsub("less than ", "")
    s = s.gsub("a minute", "1 minute")
    "#{s} ago"
  end

  def mobile?(agent = request.user_agent)
    return true if agent =~ /\b(iPad|urbanpad)\b/
    return true if agent =~ /BlackBerry|BB10.*mobile/i
    return true if agent =~ /Android/
    return true if agent =~ /\b(iPhone|iPod|CFNetwork)\b/
    return true if agent =~ /Windows Phone/

    #return true if agent =~ /^(?:ASTEL|AU-MIC|DoCoMo|J-PHONE|mot|Nokia|PDXGW|SEC|SonyEricsson|UPG1|Vodafone|Xiino)/i
    #return true if agent =~ /\b(?:Android|AvantGo|Danger|DDIPOCKET|Elaine|embedix|maemo|MIDP|NetFront|nokia\d+|Opera Mini|Palm(OS|Source)|PlayStation|ProxiNet|RegKing|ReqwirelessWeb|SonyEricsson|Symbian ?OS|TELECA|Twitt[a-z]+|UP\.Browser|WinWAPDashMR|Windows CE|Pre)\b/i
    false
  end

  def phone?(agent = request.user_agent)
    # return true if agent =~ /\b(iPad|urbanpad)\b/
    return true if agent =~ /BlackBerry|BB10.*mobile/i
    return true if agent =~ /Android/
    return true if agent =~ /\b(iPhone|iPod|CFNetwork)\b/
    return true if agent =~ /Windows Phone/

    #return true if agent =~ /^(?:ASTEL|AU-MIC|DoCoMo|J-PHONE|mot|Nokia|PDXGW|SEC|SonyEricsson|UPG1|Vodafone|Xiino)/i
    #return true if agent =~ /\b(?:Android|AvantGo|Danger|DDIPOCKET|Elaine|embedix|maemo|MIDP|NetFront|nokia\d+|Opera Mini|Palm(OS|Source)|PlayStation|ProxiNet|RegKing|ReqwirelessWeb|SonyEricsson|Symbian ?OS|TELECA|Twitt[a-z]+|UP\.Browser|WinWAPDashMR|Windows CE|Pre)\b/i
    false
  end

  # Returns ie version or 0 if not ie
  def ie_version
    browser = request.user_agent
    match = /MSIE (\d.\d*)/.match(browser)
    match ? match[1].to_i : 0
  end

  def youtube_url(code)
    args = {
      v: code,
      modestbranding: 1,
      rel: 0,
      showinfo: 1,
      autoplay: 1,
    }
    if language != 'en'
      args.merge!(
        cc_lang_pref: language,
        cc_load_policy: 1
      )
    end
    "https://www.youtubeeducation.com/embed/#{code}/?#{args.to_query}"
  end

  def video_thumbnail_url(video)
    asset_url("/c/video_thumbnails/#{video.id}.jpg")
  end

  def format_xml(xml)
    doc = Nokogiri::XML(xml)
    doc.to_xhtml
  end

  def level_box_class(best_result)
    if !best_result then 'level_untried'
    elsif best_result == Activity::BEST_PASS_RESULT then 'level_aced'
    elsif best_result < Activity::MINIMUM_PASS_RESULT then 'level_undone'
    else 'level_done'
    end
  end

  def gender_options
    User::GENDER_OPTIONS.map do |key, value|
      [(key ? t(key) : ''), value]
    end
  end

  def bullet_html
    #raw "&#9679;"
    image_tag('white-dot-grid.png')
  end

  def check_mark_html
    #raw "&#x2714;"
    image_tag('white-checkmark.png')
  end

end
