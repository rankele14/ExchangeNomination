require 'rails_helper'


RSpec.describe 'Logging in', type: :feature do

  before do
    @authorized = Authorized.create(authorized_email: "userdoe@example.com")
    Rails.application.env_config['devise.mapping'] = Devise.mappings[:admin]
    Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google_user]
    unless Admin.where(email: 'userdoe@example.com').first.nil? == false
      Admin.create!(email: 'userdoe@example.com', full_name: 'User Doe', uid: '123456789', avatar_url: 'https://lh3.googleusercontent.com/url/photo.jpg')
    end
  end
  scenario 'signing in' do
     visit root_path
	click_on 'Sign in'
    expect(page).to have_content("Successfully authenticated from Google account.")
  end

  scenario 'valid inputs' do
    visit root_path
	  click_on 'Sign in'
    click_on 'Students'
    click_on 'Add New Student'
    expect(page).to have_content("New Student")
  end

  
end


#admin add new student does not interact with limit


#admin login
#test destroy associations
#test show compound tables?
#valid email
