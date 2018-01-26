class TwitterPosts
  include ActiveModel::Model
  attr_accessor :timeline, :mentions
end