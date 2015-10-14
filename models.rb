class User < ActiveRecord::Base
  has_many :posts
  has_one :profile
  # has_many :follows, foreign_key: :followee_id
  has_many :followings, foreign_key: :follower_id, class_name: "::Following"
  has_many :followers, through: :followings, class_name: User
  has_many :followees, through: :followings, class_name: User
end


class Profile < ActiveRecord::Base
	belongs_to :user
end


class Following < ActiveRecord::Base
  belongs_to :follower, foreign_key: :follower_id, class_name: User
  belongs_to :followee, foreign_key: :followee_id, class_name: User
end


class Post < ActiveRecord::Base
  belongs_to :user
end