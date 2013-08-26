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

    Game.create!(name: 'Maze', base_url: '/blockly/branches/mooc/static/maze/index.html')
    Game.create!(name: 'Turtle', base_url: '/blockly/branches/mooc/static/turtle/index.html')
    Game.create!(name: 'Karel', base_url: '/blockly/branches/mooc/static/karel/maze.html')
  end

  task script: :environment do
    c = Script.connection
    c.execute('truncate table levels')
    c.execute('truncate table script_levels')
    script = Script.find_or_create_by_name('20-hour')

    parsed_file = CSV.read("config/script.csv", { :col_sep => "," })
    puts parsed_file.inspect

    chapter = 1
    game_map = Game.all.index_by(&:name)
    concept_map = Concept.all.index_by(&:name)
    headers = parsed_file.shift

    parsed_file.each do |row|
      game = game_map[row[0].squish]
      puts game.inspect
      level = Level.create(game: game, name: row[1], level_num: row[2])
      row[3].split(',').each do |concept_name|
        concept = concept_map[concept_name.squish]
        raise "missing concept '#{concept_name}'" if !concept
        level.concepts << concept
      end
      level.save!
      ScriptLevel.create!(script: script, level: level, chapter: chapter)
      chapter += 1
    end
  end
end
