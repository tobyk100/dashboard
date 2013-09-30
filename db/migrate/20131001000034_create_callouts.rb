class CreateCallouts < ActiveRecord::Migration
  def change
    create_table :callouts do |t|
      t.string :element_id, null: false;
      t.string :text, null: false;

      t.timestamps
    end
  end
end
