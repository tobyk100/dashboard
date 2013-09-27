require "csv"

namespace :seed do
  task videos: :environment do
    Video.connection.execute('truncate table videos')

    CSV.read('config/videos.csv', { col_sep: "\t", headers: true }).each do |row|
      Video.create!(name: row['Name'], key: row['Key'], youtube_code: row['YoutubeCode'])
    end
  end

  task concepts: :environment do
    Concept.connection.execute('truncate table concepts')

    Concept.create!(name: 'sequence', description: 'Use functions to trigger actions')
    Concept.create!(name: 'conditional 1', description: 'Use if statement to run code conditionally', video: Video.find_by_key('if'))
    Concept.create!(name: 'conditional 2', description: 'Use multiple if statements or if-else', video: Video.find_by_key('if_else'))
    Concept.create!(name: 'loop 1', description: 'Use basic loops, such as for or while statements', video: Video.find_by_key('loop_times'))
    Concept.create!(name: 'loop 2', description: 'Use of more complex loop structures', video: Video.find_by_key('loop_until'))
    Concept.create!(name: 'variable', description: 'Assign and retrieve values from variables')
    Concept.create!(name: 'function', description: 'Use of sub-routines', video: Video.find_by_key('function'))
  end

  task games: :environment do
    Concept.connection.execute('truncate table games')

    Game.create!(name: 'Maze', base_url: '/blockly/static/maze/index.html', app: 'maze', intro_video: Video.find_by_key('maze_intro'))
    Game.create!(name: 'Artist', base_url: '/blockly/static/turtle/index.html', app: 'turtle', intro_video: Video.find_by_key('artist_intro'))
    Game.create!(name: 'Farmer', base_url: '/blockly/static/maze/index.html', app: 'maze', intro_video: Video.find_by_key('farmer_intro'))
  end

  COL_GAME = 'Game'
  COL_NAME = 'Name'
  COL_LEVEL = 'Level'
  COL_INSTRUCTIONS = 'Instructions'
  COL_CONCEPTS = 'Concepts'
  COL_URL = 'Url'
  COL_SKIN = 'Skin'

  task scripts: :environment do
    c = Script.connection
    c.execute('truncate table levels')
    c.execute('truncate table concepts_levels')
    c.execute('truncate table script_levels')
    c.execute('truncate table scripts')

    game_map = Game.all.index_by(&:name)
    concept_map = Concept.all.index_by(&:name)

    sources = [
        { file: 'config/script.csv', name: '20-hour', video: Video.find_by_key('20_wrapup') },
        { file: 'config/hoc_script.csv', name: 'Hour of Code', video: Video.find_by_key('hoc_wrapup') },
    ]
    sources.each do |source|
      script = Script.create!(name: source[:name], wrapup_video: source[:video])

      CSV.read(source[:file], { col_sep: "\t", headers: true }).each_with_index do |row, index|
        game = game_map[row[COL_GAME].squish]
        puts "row #{index}: #{row.inspect}"
        level = Level.find_or_create_by_game_id_and_name_and_level_num(game.id, row[COL_NAME], row[COL_LEVEL])
        level.level_url ||= row[COL_URL]
        level.instructions ||= row[COL_INSTRUCTIONS]
        level.skin ||= row[COL_SKIN]

        if level.concepts.empty?
          if row[COL_CONCEPTS]
            row[COL_CONCEPTS].split(',').each do |concept_name|
              concept = concept_map[concept_name.squish]
              if !concept
                puts "missing concept '#{concept_name}'"
              else
                level.concepts << concept
              end
            end
          end
          level.save!
        end
        ScriptLevel.create!(script: script, level: level, chapter: (index + 1))
      end
    end
  end

  task trophies: :environment do
    Trophy.connection.execute('truncate table trophies')
    Trophy.create!(name: 'Bronze', image_name: 'bronzetrophy.png')
    Trophy.create!(name: 'Silver', image_name: 'silvertrophy.png')
    Trophy.create!(name: 'Gold', image_name: 'goldtrophy.png')
  end

  task all: [:videos, :concepts, :games, :scripts, :trophies]
end
