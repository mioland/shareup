class Post < ApplicationRecord
    belongs_to :user
    has_many :photos, dependent: :destroy
    acts_as_taggable
    has_many :likes, -> { order(created_at: :desc) }, dependent: :destroy

    def liked_by(user)
      Like.find_by(user_id: user.id, post_id: id)
    end
  end