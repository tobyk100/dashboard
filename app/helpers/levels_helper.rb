module LevelsHelper
  def build_script_level_path(script_level)
    script_level_path(script_level.script, script_level.level)
  end

  # this defines which levels should be seeded with th last result from a different level
  def initial_blocks(user, level)
    if user
      if level.game.app == 'turtle'
        source_level_num = case level.level_num
          when '3_8' then '3_7'
          when '3_9' then '3_8'
        end

        if source_level_num
          source_level = Level.find_by_game_id_and_level_num(level.game_id, source_level_num)
          return user.last_attempt(source_level).try(:data)
        end
      end
    end
    nil
  end

  def start_blocks(user, level)
    return initial_blocks(user, level) ?
      'startBlocks: \'' + initial_blocks(user, level) + '\'' : nil;
  end

  def language
    user.try(:language) || 'en'
  end

  def locale
    'en_us'
  end
end
