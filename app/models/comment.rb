class Comment < ApplicationRecord
    belongs_to :post
    belongs_to :user
    has_one :notification, dependent: :destroy
    validates :comment, presence: true
end