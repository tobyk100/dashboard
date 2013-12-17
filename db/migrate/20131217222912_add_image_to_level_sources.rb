class AddImageToLevelSources < ActiveRecord::Migration
  def change
    add_column :level_sources, :image, :binary
  end
end
