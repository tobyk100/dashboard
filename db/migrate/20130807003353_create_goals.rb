class CreateGoals < ActiveRecord::Migration
  def change
    create_table :goals do |t|
      t.references :provider
      t.string :name # for display
      t.string :token # for apis
      t.string :goal_type # level, concept, time spent, attempts
      t.timestamps
    end
  end
end
