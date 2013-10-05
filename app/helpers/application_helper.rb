require 'nokogiri'

module ApplicationHelper
  def ago(from_time)
    s = distance_of_time_in_words_to_now(from_time)
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

  def build_youtube_link(code)
    "https://www.youtubeeducation.com/watch?v=#{code}"
  end

  def format_xml(xml)
    doc = Nokogiri::XML(xml)
    doc.to_xhtml
  end
end
