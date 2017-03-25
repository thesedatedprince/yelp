module RestaurantsHelper
  def reviews_for_restaurant(id)
    @reviews = Review.where(:restaurant_id => id)
  end
end
