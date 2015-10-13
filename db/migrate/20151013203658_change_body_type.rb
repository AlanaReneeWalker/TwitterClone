class ChangeBodyType < ActiveRecord::Migration
  def change
  	remove_column :posts, :body, :string
  	add_column :posts, :body, :text
  end
end
