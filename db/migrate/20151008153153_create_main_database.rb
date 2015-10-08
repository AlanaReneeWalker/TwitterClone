class CreateMainDatabase < ActiveRecord::Migration
  def change
  	create_table :users do |t|
  		t.string :fname
  		t.string :lname
  		t.string :email
      t.string :password
      t.string :username
  	end
    create_table :posts do |t|
  		t.string :subject
  		t.string :body
  		t.integer :user_id
      t.datetime :time
  	end
  	create_table :profiles do |t|
  		t.string :posts
      t.integer :post_id
  		t.integer :user_id
  	end
    create_table :following do |t|
      t.string :username
      t.integer :user_id
    end
  end
end
