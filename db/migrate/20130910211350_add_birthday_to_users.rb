class AddBirthdayToUsers < ActiveRecord::Migration
  def change
    add_column :users, :birthday, :date
    add_column :users, :parent_email, :string
  end
end
