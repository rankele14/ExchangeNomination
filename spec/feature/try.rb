require 'rails_helper'

RSpec.describe 'Admin question functions', type: :feature do
    before do
      @authorized = Authorized.create(authorized_email: "userdoe@example.com")
      Rails.application.env_config['devise.mapping'] = Devise.mappings[:admin]
      Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google_user]
      unless Admin.where(email: 'userdoe@example.com').first.nil? == false
        Admin.create!(email: 'userdoe@example.com', full_name: 'User Doe', uid: '123456789', avatar_url: 'https://lh3.googleusercontent.com/url/photo.jpg')
      end
      visit root_path
      click_on 'Admin login'
    end
    scenario 'delete answer' do
        visit new_question_path
        click_on 'Create Question'
        fill_in 'Prompt', with: 'multi'
        check 'question_multi'
        click_on 'Create Question'
        click_on 'View Answers'
        click_on 'New Answer'
        fill_in 'Choice', with: '1'
        click_on 'Create Answer'
        click_on 'Delete Choice'
        # not using delete page
        # expect(page).to have_content('xxx')
        # click_on 'Delete Choice'
        expect(page).not_to have_content('1')
    end
end


RSpec.describe 'User representative functions', type: :feature do
    before do
      @authorized = Authorized.create(authorized_email: "userdoe@example.com")
      Rails.application.env_config['devise.mapping'] = Devise.mappings[:admin]
      Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google_user]
      unless Admin.where(email: 'userdoe@example.com').first.nil? == false
        Admin.create!(email: 'userdoe@example.com', full_name: 'User Doe', uid: '123456789', avatar_url: 'https://lh3.googleusercontent.com/url/photo.jpg')
      end
      visit root_path # need to create university first
        click_on 'Admin login'
        visit admin_path
          fill_in 'deadline', with: DateTime.current + 3.days
          click_on 'Update'
        visit universities_path
          fill_in 'max_lim', with: '3'
          click_on 'Update Default Limit'
          visit universities_path
          expect(page).to have_content('3')
        visit new_university_path
          fill_in 'University name', with: 'UniName'
          click_on 'Create University'
          expect(page).to have_content('UniName 0 3')
    end
  
    scenario 'create representative' do
      visit user_new_representatives_path
        click_on 'Create Representative'
        expect(page).to have_content('error')
        select 'UniName', :from => 'University'
        fill_in 'First name', with: 'John'
        fill_in 'Last name', with: 'Smith'
        fill_in 'Title', with: 'CEO'
        fill_in 'Email', with: 'JohnSmith@gmail.com'
      click_on 'Create Representative'
        expect(page).to have_content('John')
        expect(page).to have_content('Smith')
        expect(page).to have_content('CEO')
        expect(page).to have_content('JohnSmith@gmail.com')
        # expect to go to user_show after fail, Continue instead of Back
        click_on('Continue'); # expect user_show
    end
end