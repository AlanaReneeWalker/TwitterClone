class AddColumnToUsername < ActiveRecord::Migration
  def change
  	remove_column :following, :username, :string
  	remove_column :following, :user_id, :integer
  	add_column :following, :follower_id, :integer
  	add_column :following, :followee_id, :integer
  	
  end
end
