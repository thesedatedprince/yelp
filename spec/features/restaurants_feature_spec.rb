require 'rails_helper'
require_relative 'web_helpers'

feature 'restaurants' do

  context 'user is not logged in' do

    context 'no restaurants have been added' do
      scenario 'should display a prompt to add a restaurants' do
          visit '/restaurants'
          expect(page).to have_content 'No restaurants yet'
          expect(page).to have_link 'Add a restaurant'
      end
    end

    context 'restaurants have been added' do
      before do
          Restaurant.create(name: 'KFC')
      end

      scenario 'display restaurants' do
          visit '/restaurants'
          expect(page).to have_content 'KFC'
          expect(page).not_to have_content 'No restaurants yet'
      end
    end

    context 'viewing restaurants' do
      let!(:kfc){Restaurant.create(name:'KFC')}
        scenario 'lets a user view a restaurant' do
          visit '/restaurants'
          click_link 'KFC'
          expect(page).to have_content 'KFC'
          expect(current_path).to eq "/restaurants/#{kfc.id}"
        end
    end

    context 'adding restaurants' do
      scenario 'user tries to add a restaurant' do
        visit '/'
        click_link 'Add a restaurant'
        expect(page).to have_content 'Log in'
        expect(current_path).to eq '/users/sign_in'
      end
    end
  end

  context 'user is logged in' do
    before do
      signup
    end

    context 'editing restaurants' do #
      before { Restaurant.create name: 'KFC', description: 'Deep fried goodness', id: 1 }
      scenario 'let the user edit a restaurant' do
        visit '/restaurants'
        click_link 'Edit KFC'
        fill_in 'Name', with: 'Kentucky Fried Chicken'
        fill_in 'Description', with: 'Deep fried goodness'
        click_button 'Update Restaurant'
        click_link 'Kentucky Fried Chicken'
        expect(page).to have_content 'Kentucky Fried Chicken'
        expect(page).to have_content 'Deep fried goodness'
        expect(current_path).to eq "/restaurants/1"
      end
    end

    context 'deleting restaurants' do #
      scenario 'removes the restaurant when the user clicks a delete link' do
        Restaurant.create(name: 'KFC', description: 'Deep fried goodness')
        visit '/restaurants'
        click_link 'Delete KFC'
        expect(page).not_to have_content 'KFC'
        expect(page).to have_content 'Restaurant deleted succesfully'
      end

      scenario 'user1 tries to delete restaurant of user2' do
        visit '/restaurants'
        click_link 'Delete KFC'
        expect(page).to have_content 'KFC'
        expect(page).to have_content 'Restaurant cannot be deleted'
      end
    end

    context 'creating restaurants' do #
      scenario 'prompt the user to fill out a form, then display the restaurant' do
        visit '/restaurants'
        click_link 'Add a restaurant'
        fill_in 'Name', with: 'KFC'
        click_button 'Create restaurant'
        expect(page).to have_content 'KFC'
        expect(current_path).to eq '/restaurants'
      end
    end

    context 'an invalid restaurant' do
      scenario 'does not let you submit a name that is too short' do
        visit '/restaurants'
        click_link 'Add a restaurant'
        fill_in 'Name', with: 'kf'
        click_button 'Create restaurant'
        expect(page).not_to have_css 'h2', text: 'kf'
        expect(page).to have_content 'error'
      end
    end
  end
end
