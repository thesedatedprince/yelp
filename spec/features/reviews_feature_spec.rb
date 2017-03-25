require 'rails_helper'

feature 'reviewing' do
  before { Restaurant.create name: "KFC" }

  scenario 'allows users to leave a review using a form' do
    signup
    visit '/restaurants'
    click_link 'Review KFC'
    fill_in 'Thoughts', with: 'so so'
    select '3', from: 'Rating'
    click_button 'Leave Review'

    expect(current_path).to eq '/restaurants'
    expect(page).to have_content 'so so'
  end

  scenario 'displays an average rating for all reviews' do
    signup
    leave_review('So so', '3')
    click_link 'Sign out'
    signup(email: "linda@test.com")
    leave_review('Great', '5')
    expect(page).to have_content('Average rating: ★★★★☆')
  end


end
