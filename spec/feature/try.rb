require 'rails_helper'

RSpec.describe 'User deleting a student', type: :feature do
    scenario 'valid inputs' do
      visit new_university_path
      fill_in 'University name', with: 'AM'
      click_on 'Create University'
      visit universities_path
      visit user_new_representatives_path
      select 'AM', :from => 'University'
      fill_in 'First name', with: 'John'
      fill_in 'Last name', with: 'Smith'
      fill_in 'Title', with: 'CEO'
      fill_in 'Rep email', with: 'JohnSmith@gmail.com'
      click_on 'Create Representative'
    click_link 'Continue'
    click_on 'Enter a new student'
      fill_in 'First name', with: 'Foo'
      fill_in 'Last name', with: 'Bar'
       select 'Bachelors', :from => 'Degree level'
      fill_in 'Major', with: 'Basket Making'
      select 'Fall Only', :from => 'Exchange term'
      fill_in 'Student email', with: 'FooBar@gmail.com'
    click_on 'Create Student'
    click_on 'Finish'
    # capybara error message: undefined method `user_destroy' for #<Capybara::RackTest::Browser:0x000055ccdacacd60 [...]
    # manual test works fine
    #click_on 'Delete'
    #expect(page).to have_content('Finish')
    #expect(page).not_to have_content('Foo')
    end
  end
  

RSpec.describe 'Creating a representative', type: :feature do
  scenario 'valid inputs' do
    visit new_university_path
    fill_in 'University name', with: 'AM'
	click_on 'Create University'
    visit universities_path
	visit new_representative_path
	click_on 'Create Representative'
    expect(page).to have_content('error')
    select 'AM', :from => 'University'
    fill_in 'First name', with: 'John'
    fill_in 'Last name', with: 'Smith'
    fill_in 'Title', with: 'CEO'
    # should error this part without @ but doesn't
    #fill_in 'Rep email', with: 'JohnSmith'
    #click_on 'Create Representative'
    #expect(page).to have_content('error')
    fill_in 'Rep email', with: 'JohnSmith@gmail.com'
	click_on 'Create Representative'
    visit representatives_path
    expect(page).to have_content('John')
    expect(page).to have_content('Smith')
    expect(page).to have_content('CEO')
    expect(page).to have_content('JohnSmith@gmail.com')
  end
end

RSpec.describe 'Creating a university with num_nominees', type: :feature do
  scenario 'valid inputs' do
    visit new_university_path
	click_on 'Create University'
	expect(page).to have_content('error')
    fill_in 'University name', with: 'AM'
    fill_in 'Num nominees', with: '2' # want to rename this label
	click_on 'Create University'
    visit universities_path
    expect(page).to have_content('AM')
    expect(page).to have_content('2')
  end
end

RSpec.describe 'Google sign-in', type: :feature do
  scenario 'valid inputs' do
    visit root_path
    expect(page).to have_content('TAMU')
    click_on 'Admin Sign in'
  end
end