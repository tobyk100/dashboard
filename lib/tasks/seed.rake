require "csv"

namespace :seed do
  task db: :environment do
    c = Concept.connection
    c.execute('truncate table concepts')
    c.execute('truncate table games')

    Concept.create!(name: 'sequence 1', description: 'Use functions to trigger actions')
    Concept.create!(name: 'conditional 1', description: 'Use if statement to run code conditionally')
    Concept.create!(name: 'conditional 2', description: 'Use multiple if statements or if-else')
    Concept.create!(name: 'loop 1', description: 'Use basic loops, such as for or while statements')
    Concept.create!(name: 'loop 2', description: 'Use of more complex loop structures')
    Concept.create!(name: 'loop 3', description: 'Use of advanced loop structures')
    Concept.create!(name: 'variable 1', description: 'Basic variables, such as a for loop iterator')
    Concept.create!(name: 'variable 2', description: 'More complex variables')
    Concept.create!(name: 'data structures 1', description: 'Use of non-native types, such as arrays and hashes')
    Concept.create!(name: 'function 1', description: 'Use of sub-routines')
    Concept.create!(name: 'function 2', description: 'Use of sub-routines intermediate')
    Concept.create!(name: 'function 3', description: 'Use of sub-routines advanced')

    Game.create!(name: 'Maze', base_url: '/blockly/static/maze/index.html?mode=2&skin=3')
    Game.create!(name: 'Turtle', base_url: '/blockly/static/turtle/index.html')
    Game.create!(name: 'Karel', base_url: '/blockly/static/karel/maze.html')
    Game.create!(name: 'Video')
  end

  COL_GAME = 0
  COL_NAME = 1
  COL_PAGE = 2
  COL_LEVEL = 3
  COL_CONCEPTS = 4
  COL_URL = 5

  task script: :environment do
    c = Script.connection
    c.execute('truncate table levels')
    c.execute('truncate table concepts_levels')
    c.execute('truncate table script_levels')

    game_map = Game.all.index_by(&:name)
    concept_map = Concept.all.index_by(&:name)

    sources = [
        { file: 'config/script.csv', name: '20-hour' },
        { file: 'config/hoc_script.csv', name: 'Hour of Code' },
    ]
    sources.each do |source|
      script = Script.find_or_create_by_name(source[:name])
      parsed_file = CSV.read(source[:file], { :col_sep => "\t" })

      headers = parsed_file.shift
      # todo: use header to index into columns, rather than hard coded indexes

      parsed_file.each_with_index do |row, index|
        game = game_map[row[COL_GAME].squish]
        puts "row #{index}: #{row.inspect}"
        level = Level.find_or_create_by_game_id_and_name_and_page_and_level_num(game.id, row[COL_NAME], row[COL_PAGE], row[COL_LEVEL])
        level.level_url ||= row[COL_URL]

        if level.concepts.empty?
          if row[COL_CONCEPTS]
            row[COL_CONCEPTS].split(',').each do |concept_name|
              concept = concept_map[concept_name.squish]
              raise "missing concept '#{concept_name}'" if !concept
              level.concepts << concept
            end
          end
          level.save!
        end
        ScriptLevel.create!(script: script, level: level, chapter: (index + 1))
      end
    end
  end
end
