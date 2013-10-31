module LevelsHelper
  def build_script_level_path(script_level)
    if Script::HOC_ID == script_level.script_id
      hoc_chapter_path(script_level.chapter)
    else
      script_level_path(script_level.script, script_level)
    end
  end

  # this defines which levels should be seeded with th last result from a different level
  def initial_blocks(user, level)
    if params[:initial_code]
      return params[:initial_code]
    end

    if user
      if level.game.app == 'turtle'
        from_level_num = case level.level_num
          when '3_8' then '3_7'
          when '3_9' then '3_8'
        end

        if from_level_num
          from_level = Level.find_by_game_id_and_level_num(level.game_id, from_level_num)
          return user.last_attempt(from_level).try(:level_source).try(:data)
        end
      end
    end
    nil
  end

  def start_blocks(user, level)
    return initial_blocks(user, level) ?
      'startBlocks: \'' + initial_blocks(user, level) + '\'' : nil;
  end

  #XXX Since Blockly doesn't play nice with the asset pipeline. Capistrano
  # writes a revision file whose content is threaded through both Blockly apps
  # and core as a query params for cache busting. Forwarding of query params
  # is enabled in CloudFront CDN. Always cache bust during development.
  def blockly_cache_bust
    if ::GIT_REVISION.blank?
      Time.now.to_i.to_s
    else
      ::GIT_REVISION
    end
  end
end
