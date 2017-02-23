require_relative "with_user_extension"

class Restaurant < ApplicationRecord
  has_many :reviews,
      -> { extending WithUserAssociationExtension }, dependent: :destroy

  validates :name, length: {minimum: 3}, uniqueness: true

  def build_review(attributes = {}, user)
    review = reviews.build(attributes)
    review.user = user
    review
  end
end
