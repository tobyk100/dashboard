module FollowersHelper
  def build_user_level_message(user, user_level, script_level)
    if user_level
      #TODO: Localize
      return <<TEXT
#{user.name}
#{script_level.level.game.name} ##{script_level.game_chapter}
Best result: #{user_level.best_result}
Attempts: #{user_level.attempts}
Last attempt: #{time_ago_in_words(user_level.updated_at)}
First attempt: #{time_ago_in_words(user_level.created_at)}
TEXT
    else
      return "#{user.name} has not attempted #{script_level.level.game.name} ##{script_level.game_chapter}"
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

  def build_invite_mailto(section, user)
    "mailto:?subject=#{Rack::Utils.escape(t('welcome_email.subject'))}&body=#{Rack::Utils.escape(t('welcome_email.body', link: student_user_new_url(section_code: section.code), name: user.name))}"
  end
end
