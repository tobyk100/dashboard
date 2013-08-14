class AddBaseUrlToGames < ActiveRecord::Migration
  def change
    add_column :games, :base_url, :string
    add_column :levels, :level_num, :integer
    add_column :users, :language, :string, limit: 2
  end
end
