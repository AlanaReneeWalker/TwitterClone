class TableNameChangeToFollowings < ActiveRecord::Migration
  def change
  	rename_table :following, :followings
  end
end