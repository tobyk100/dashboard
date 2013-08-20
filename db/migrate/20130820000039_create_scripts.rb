class CreateScripts < ActiveRecord::Migration
  def change
    create_table :scripts do |t|
      t.string :name

      t.timestamps
    end

    create_table :script_levels do |t|
      t.references :level, :script
      t.integer :chapter

      t.timestamps
    end
  end
end
