module FollowersHelper
  def build_user_level_message(user_level, script_level)
    if user_level
      return <<TEXT
#{user_level.user.name}
#{script_level.level.game.name} ##{script_level.game_chapter}
Best result: #{user_level.best_result}
Attempts: #{user_level.attempts}
Last attempt: #{time_ago_in_words(user_level.updated_at)}
First attempt: #{time_ago_in_words(user_level.created_at)}
TEXT
    else
      return "#{script_level.level.game.name}: #{script_level.level.level_num}\nNot attempted yet"
    end
  end
end
