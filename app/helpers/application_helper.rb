module ApplicationHelper
  def ago(from_time)
    s = distance_of_time_in_words_to_now(from_time)
    s = s.gsub("about ", "")
    s = s.gsub("less than ", "")
    s = s.gsub("a minute", "1 minute")
    "#{s} ago"
  end
end
