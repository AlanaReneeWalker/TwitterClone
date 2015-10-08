class User < ActiveRecord::Base
  # the way we describe follows is as a list
  #   of people that have followed you
  # when we want to see a list of all the follows we have
  #   we must tell it to look at the followee_id foreign key
  has_many :follows, foreign_key: :followee_id
  has_many :posts
  has_one :profile
end

class Profile < ActiveRecord::Base
	belongs_to :user
end

class Follow < ActiveRecord::Base
  # when we want to see a list of all follows,
  #   we must indicate that when we do a <follow object>.user
  #   it needs to look at the follower_id foreign key
  belongs_to :user, foreign_key: :follower_id
end

class Post < ActiveRecord::Base
  belongs_to :user
end