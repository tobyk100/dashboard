require "csv"

namespace :seed do
  task db: :environment do
    c = Concept.connection
    c.execute('truncate table concepts')
    c.execute('truncate table games')

    Concept.create!(name: 'output 1', description: 'Use functions to trigger actions')
    Concept.create!(name: 'conditional 1', description: 'Use if statement to run code conditionally')
    Concept.create!(name: 'conditional 2', description: 'Use multiple if statements or if-else')
    Concept.create!(name: 'loop 1', description: 'Use basic loops, such as for or while statements')
    Concept.create!(name: 'loop 2', description: 'Use of more complex loop structures')
    Concept.create!(name: 'variables 1', description: 'Basic variables, such as a for loop iterator')
    Concept.create!(name: 'variables 2', description: 'More complex variables')
    Concept.create!(name: 'data structures 1', description: 'Use of non-native types, such as arrays and hashes')

    Game.create!(name: 'Maze', base_url: '/blockly/static/maze/index.html')
    Game.create!(name: 'Turtle', base_url: '/blockly/static/turtle/index.html')
    Game.create!(name: 'Karel', base_url: '/blockly/static/karel/maze.html')
    Game.create!(name: 'Video')
  end

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
        game = game_map[row[0].squish]
        puts "row #{index}: #{row.inspect}"
        level = Level.find_or_create_by_game_id_and_name_and_level_num(game.id, row[1], row[2])
        level.level_url ||= row[4]

        if level.concepts.empty?
          if row[3]
            row[3].split(',').each do |concept_name|
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
