class CreateCallouts < ActiveRecord::Migration
  def change
    create_table :callouts do |t|
      t.string :element_id
      t.string :text

      t.timestamps
    end
  end
end
