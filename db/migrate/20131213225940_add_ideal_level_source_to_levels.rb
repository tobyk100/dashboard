class AddIdealLevelSourceToLevels < ActiveRecord::Migration
  def change
    add_column :levels, :ideal_level_source_id, :integer
  end
end
