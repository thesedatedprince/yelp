require_relative "with_user_extension"

class Restaurant < ApplicationRecord
  has_many :reviews,
      -> { extending WithUserAssociationExtension }, dependent: :destroy

  validates :name, length: {minimum: 3}, uniqueness: true

  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

  def build_review(attributes = {}, user)
    review = reviews.build(attributes)
    review.user = user
    review
  end

  def average_rating
    return 'N/A' if reviews.none?
    review = reviews.map {|review| review.rating}
    reviews.inject(0) {|memo, review| memo + review.rating}/review.length
  end
end
