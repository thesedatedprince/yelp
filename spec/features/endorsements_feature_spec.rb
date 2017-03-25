require 'rails_helper'

feature 'endorsing reviews' do
  before do
    signup
    click_link 'Add a restaurant'
    fill_in 'Name', with: 'KFC'
    click_button 'Create Restaurant'
    expect(page).to have_content 'KFC'
    leave_review('So so', '3')
  end

  it 'a user can endorse a review, which updates the review endorsement count', js:true do
    visit '/restaurants'
    click_link 'Endorse'
    expect(page).to have_content("1 endorsement")
  end

end
