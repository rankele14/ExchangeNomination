require 'rails_helper'

OmniAuth.config.silence_get_warning = true

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
	  click_on 'Admin login'
    expect(page).to have_content("Successfully authenticated from Google account.")
    expect(page).to have_content("Admin Home Page")
  end

  scenario 'valid inputs' do
    visit root_path
	  click_on 'Admin login'
    expect(page).to have_content("Admin Home Page")
  end  

  scenario 'signing in' do
    visit root_path
	  click_on 'Admin login'
    expect(page).to have_content("Successfully authenticated from Google account.")
    expect(page).to have_content("Admin Home Page")
  end
end


################################### admin CUD functions ###########################

RSpec.describe 'Admin dashboard links', type: :feature do
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

  scenario 'Universities link' do
    visit admin_path
    click_on 'Universities'
    expect(page).to have_content('New University')
    expect(page).to have_content('Back to Admin')
    # expect help and nav bar?
  end

  scenario 'Nominators link' do
    visit admin_path
    click_on 'Nominators'
    expect(page).to have_content('New Nominator')
    expect(page).to have_content('Back to Admin')
  end

  scenario 'Students link' do
    visit admin_path
    click_on 'Students'
    expect(page).to have_content('New Student')
    expect(page).to have_content('Back to Admin')
  end

  scenario 'Questions link' do
    visit admin_path
    click_on 'Questions'
    expect(page).to have_content('New Question')
    expect(page).to have_content('Back to Admin')
  end

  scenario 'Admin list link' do
    visit admin_path
    click_on 'Admin list'
    expect(page).to have_content('New Admin')
    expect(page).to have_content('Back to Admin')
  end

  scenario 'Export' do
    visit root_path
	  click_on 'Admin login'
    click_on 'Export Students'
  end

  # FIXME responses?
  # not including deadline here

  scenario 'Return link' do
    visit admin_path
    click_on 'Return to Home Page'
    expect(page).to have_content('Nominator Info')
  end

  # scenario 'Help page' do
  #   visit admin_path
  #   click_on 'Help'
  #   expect(page).to have_content('')
  # end

  scenario 'Sign out' do
    visit admin_path
    click_on 'Sign Out'
    expect(page).to have_content('Signed out')
    expect(page).to have_content('Nominator Info')
  end
end

RSpec.describe 'Admin university functions', type: :feature do
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

  # new/create
  scenario 'create university with defaults' do
    visit new_university_path
    expect(page).to have_content('New University')
      click_on 'Create University'
      expect(page).to have_content('error')
      fill_in 'University name', with: 'AM'
      click_on 'Create University'
    visit universities_path
      expect(page).to have_content('AM')
      expect(page).to have_content('0')
      expect(page).to have_content('3')
    click_on 'Show'
      expect(page).to have_content('AM')
      expect(page).to have_content('0')
      expect(page).to have_content('3')
  end

  scenario 'create university and change defaults' do
    visit new_university_path
      click_on 'Create University'
      expect(page).to have_content('error')
      fill_in 'University name', with: 'AM'
      fill_in 'Num nominees', with: '2'
      fill_in 'Max limit', with: '17'
      click_on 'Create University'
    visit universities_path
      expect(page).to have_content('AM')
      expect(page).to have_content('2')
      expect(page).to have_content('17')
  end

  # edit/update
  scenario 'editing university' do
    visit new_university_path
      fill_in 'University name', with: 'AM'
      click_on 'Create University'
    visit universities_path
    click_on 'Edit'
      fill_in 'University name', with: ''
      click_on 'Update University'
      expect(page).to have_content('error')
      fill_in 'University name', with: 'UT'
      fill_in 'Num nominees', with: '2'
      fill_in 'Max limit', with: '17'
    click_on 'Update University'
      visit universities_path
      expect(page).to have_content('UT')
      expect(page).to have_content('2')
      expect(page).to have_content('17') #FIXME bug if max_limit lower than num_students
  end

  # delete/destroy
  scenario 'deleting university' do
    visit new_university_path
      fill_in 'University name', with: 'AM'
      click_on 'Create University'
    visit universities_path
    click_on 'Delete'
      click_on 'Delete University'
      expect(page).not_to have_content('AM')
  end
  
  scenario 'check destroy association' do
    visit new_university_path
      fill_in 'University name', with: 'AM'
      click_on 'Create University'
    visit new_representative_path
      select 'AM', :from => 'University'
      fill_in 'First name', with: 'John'
      fill_in 'Last name', with: 'Smith'
      fill_in 'Title', with: 'CEO'
      fill_in 'Rep email', with: 'JohnSmith@gmail.com'
      click_on 'Create Representative'
    visit new_student_path
      select 'AM', :from => 'University'
      fill_in 'First name', with: 'Foo'
      fill_in 'Last name', with: 'Bar'
      select 'Bachelors', :from => 'Degree level'
      fill_in 'Major', with: 'Basket Making'
      select 'Fall Only', :from => 'Exchange term'
      fill_in 'Student email', with: 'FooBar@gmail.com'
      select 'Smith, John', :from => 'Representative'
      click_on 'Create Student'
    visit universities_path
      click_on 'Delete'
      click_on 'Delete University'
      expect(page).not_to have_content('AM')
      visit representatives_path
      expect(page).not_to have_content('John')
      visit students_path
      expect(page).not_to have_content('Foo')
  end

  # max update
  scenario 'update default max limit' do 
    visit universities_path
      expect(page).to have_content('3')
      fill_in 'max_lim', with: '-1'
      click_on 'Update Default Limit'
      expect(page).to have_content('cannot be negative')
      fill_in 'max_lim', with: '9999'
      click_on 'Update Default Limit'
      expect(page).to have_content('capped at 100')
      fill_in 'max_lim', with: '5'
    click_on 'Update Default Limit'
      expect(page).not_to have_content('3')
      expect(page).to have_content('5')
      expect(page).to have_content('successful')
  end

  scenario 'change all max limits' do 
    visit new_university_path
      fill_in 'University name', with: 'AM'
      click_on 'Create University'
      visit new_university_path
      fill_in 'University name', with: 'TU'
      click_on 'Create University'
    visit universities_path
      fill_in 'change_lim', with: '-1'
      click_on 'Change All Limits'
      expect(page).to have_content('cannot be negative')
      fill_in 'change_lim', with: '9999'
      click_on 'Change All Limits'
      expect(page).to have_content('capped at 100')
      fill_in 'change_lim', with: '5'
    click_on 'Change All Limits'
      expect(page).to have_content('AM 0 5')
      expect(page).to have_content('TU 0 5')
      expect(page).to have_content('successful')
  end

  scenario 'clear all' do
    visit new_university_path
      fill_in 'University name', with: 'AM'
      click_on 'Create University'
      visit new_university_path
      fill_in 'University name', with: 'TU'
      click_on 'Create University'
    visit new_representative_path
      select 'AM', :from => 'University'
      fill_in 'First name', with: 'John'
      fill_in 'Last name', with: 'Smith'
      fill_in 'Title', with: 'CEO'
      fill_in 'Rep email', with: 'JohnSmith@gmail.com'
      click_on 'Create Representative'
    visit new_student_path
      select 'AM', :from => 'University'
      fill_in 'First name', with: 'Foo'
      fill_in 'Last name', with: 'Bar'
      select 'Bachelors', :from => 'Degree level'
      fill_in 'Major', with: 'Basket Making'
      select 'Fall Only', :from => 'Exchange term'
      fill_in 'Student email', with: 'FooBar@gmail.com'
      select 'Smith, John', :from => 'Representative'
      click_on 'Create Student'
    visit new_representative_path
      select 'TU', :from => 'University'
      fill_in 'First name', with: 'Jackie'
      fill_in 'Last name', with: 'Garcia'
      fill_in 'Title', with: 'Director'
      fill_in 'Rep email', with: 'JackieGarcia@yahoo.com'
      click_on 'Create Representative'
    visit new_student_path
      select 'TU', :from => 'University'
      fill_in 'First name', with: 'Test'
      fill_in 'Last name', with: 'Two'
      select 'Bachelors', :from => 'Degree level'
      fill_in 'Major', with: 'Basket Making'
      select 'Fall Only', :from => 'Exchange term'
      fill_in 'Student email', with: 'FooBar@gmail.com'
      select 'Garcia, Jackie', :from => 'Representative'
      click_on 'Create Student'
    visit universities_path
    click_on 'Clear All'
      click_on 'Clear All Universities'
    visit universities_path
      expect(page).not_to have_content('AM')
      expect(page).not_to have_content('TU')
    visit representatives_path
      expect(page).not_to have_content('John')
      expect(page).not_to have_content('Jackie')
    visit students_path
      expect(page).not_to have_content('Foo')
      expect(page).not_to have_content('Test')
  end

  scenario 'reset all' do
    visit new_university_path
      fill_in 'University name', with: 'AM'
      click_on 'Create University'
      visit new_university_path
      fill_in 'University name', with: 'TU'
      click_on 'Create University'
    visit new_representative_path
      select 'AM', :from => 'University'
      fill_in 'First name', with: 'John'
      fill_in 'Last name', with: 'Smith'
      fill_in 'Title', with: 'CEO'
      fill_in 'Rep email', with: 'JohnSmith@gmail.com'
      click_on 'Create Representative'
    visit new_student_path
      select 'AM', :from => 'University'
      fill_in 'First name', with: 'Foo'
      fill_in 'Last name', with: 'Bar'
      select 'Bachelors', :from => 'Degree level'
      fill_in 'Major', with: 'Basket Making'
      select 'Fall Only', :from => 'Exchange term'
      fill_in 'Student email', with: 'FooBar@gmail.com'
      select 'Smith, John', :from => 'Representative'
      click_on 'Create Student'
    visit new_representative_path
      select 'TU', :from => 'University'
      fill_in 'First name', with: 'Jackie'
      fill_in 'Last name', with: 'Garcia'
      fill_in 'Title', with: 'Director'
      fill_in 'Rep email', with: 'JackieGarcia@yahoo.com'
      click_on 'Create Representative'
    visit new_student_path
      select 'TU', :from => 'University'
      fill_in 'First name', with: 'Test'
      fill_in 'Last name', with: 'Two'
      select 'Bachelors', :from => 'Degree level'
      fill_in 'Major', with: 'Basket Making'
      select 'Fall Only', :from => 'Exchange term'
      fill_in 'Student email', with: 'FooBar@gmail.com'
      select 'Garcia, Jackie', :from => 'Representative'
      click_on 'Create Student'
    visit universities_path
    click_on 'Reset All'
      expect(page).to have_content('Reset')
      click_on 'Reset All Universities'
    visit universities_path
      expect(page).to have_content('AM 0 3')
      expect(page).to have_content('TU 0 3')
    visit representatives_path
      expect(page).not_to have_content('John')
      expect(page).not_to have_content('Jackie')
    visit students_path
      expect(page).not_to have_content('Foo')
      expect(page).not_to have_content('Test')
  end
end

RSpec.describe 'Admin representative functions', type: :feature do
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

  # new/create
  scenario 'create representative' do
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
      # FIXME should error this part without @ but doesn't
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
  
  # edit/update
  scenario 'editing a representative' do
    visit new_university_path
      fill_in 'University name', with: 'AM'
      click_on 'Create University'
    visit new_representative_path
      select 'AM', :from => 'University'
      fill_in 'First name', with: 'John'
      fill_in 'Last name', with: 'Smith'
      fill_in 'Title', with: 'CEO'
      fill_in 'Rep email', with: 'JohnSmith@gmail.com'
      click_on 'Create Representative'
    visit representatives_path
    click_on 'Edit'
      fill_in 'First name', with: ''
      click_on 'Update Representative'
      expect(page).to have_content('error')
      fill_in 'First name', with: 'Alice'
      click_on 'Update Representative'
    visit representatives_path
      expect(page).to have_content('Alice')
  end

  scenario 'editing a representative\'s university' do
    visit new_university_path
      fill_in 'University name', with: 'AM'
      click_on 'Create University'
      visit new_university_path
      fill_in 'University name', with: 'TU'
      click_on 'Create University'
    visit new_representative_path
      select 'AM', :from => 'University'
      fill_in 'First name', with: 'John'
      fill_in 'Last name', with: 'Smith'
      fill_in 'Title', with: 'CEO'
      fill_in 'Rep email', with: 'JohnSmith@gmail.com'
      click_on 'Create Representative'
    visit new_student_path
      select 'AM', :from => 'University'
      fill_in 'First name', with: 'Foo'
      fill_in 'Last name', with: 'Bar'
      select 'Bachelors', :from => 'Degree level'
      fill_in 'Major', with: 'Basket Making'
      select 'Fall Only', :from => 'Exchange term'
      fill_in 'Student email', with: 'FooBar@gmail.com'
      select 'Smith, John', :from => 'Representative'
      click_on 'Create Student'
    visit new_student_path
      select 'AM', :from => 'University'
      fill_in 'First name', with: 'Test'
      fill_in 'Last name', with: 'Two'
      select 'Bachelors', :from => 'Degree level'
      fill_in 'Major', with: 'Basket Making'
      select 'Fall and Spring', :from => 'Exchange term'
      fill_in 'Student email', with: 'TT@gmail.com'
      select 'Smith, John', :from => 'Representative'
      click_on 'Create Student'
    visit universities_path
      expect(page).to have_content('AM 3 3')
      expect(page).to have_content('TU 0 3')
    visit representatives_path
    click_on 'Edit'
      select '', :from => 'University'
      click_on 'Update Representative'
      expect(page).to have_content('error')
      select 'TU', :from => 'University'
      click_on 'Update Representative'
    visit representatives_path
      expect(page).to have_content('TU')
    visit students_path
      expect(page).to have_content('TU')
      expect(page).not_to have_content('AM')
    visit universities_path
      expect(page).to have_content('AM 0 3')
      expect(page).to have_content('TU 3 3')
  end

  # delete/destroy
  scenario 'deleting a representative' do
    visit new_university_path
      fill_in 'University name', with: 'AM'
      click_on 'Create University'
    visit new_representative_path
      select 'AM', :from => 'University'
      fill_in 'First name', with: 'John'
      fill_in 'Last name', with: 'Smith'
      fill_in 'Title', with: 'CEO'
      fill_in 'Rep email', with: 'JohnSmith@gmail.com'
      click_on 'Create Representative'
    visit representatives_path
    click_on 'Delete'
      click_on 'Delete Representative'
      expect(page).not_to have_content('John')
  end
  
  scenario 'delete associations' do
    visit new_university_path
      fill_in 'University name', with: 'AM'
      click_on 'Create University'
    visit new_representative_path
      select 'AM', :from => 'University'
      fill_in 'First name', with: 'John'
      fill_in 'Last name', with: 'Smith'
      fill_in 'Title', with: 'CEO'
      fill_in 'Rep email', with: 'JohnSmith@gmail.com'
      click_on 'Create Representative'
    visit new_student_path
      select 'AM', :from => 'University'
      fill_in 'First name', with: 'Foo'
      fill_in 'Last name', with: 'Bar'
      select 'Bachelors', :from => 'Degree level'
      fill_in 'Major', with: 'Basket Making'
      select 'Fall Only', :from => 'Exchange term'
      fill_in 'Student email', with: 'FooBar@gmail.com'
      select 'Smith, John', :from => 'Representative'
      click_on 'Create Student'
    visit representatives_path
      click_on 'Delete'
      click_on 'Delete Representative'
    visit universities_path
      expect(page).to have_content('AM 0 3')
    visit representatives_path
      expect(page).not_to have_content('John')
    visit students_path
      expect(page).not_to have_content('Foo')
  end
  
  scenario 'clear all' do
    visit new_university_path
      fill_in 'University name', with: 'AM'
      click_on 'Create University'
    visit new_representative_path
      select 'AM', :from => 'University'
      fill_in 'First name', with: 'John'
      fill_in 'Last name', with: 'Smith'
      fill_in 'Title', with: 'CEO'
      fill_in 'Rep email', with: 'JohnSmith@gmail.com'
      click_on 'Create Representative'
    visit new_student_path
      select 'AM', :from => 'University'
      fill_in 'First name', with: 'Foo'
      fill_in 'Last name', with: 'Bar'
      select 'Bachelors', :from => 'Degree level'
      fill_in 'Major', with: 'Basket Making'
      select 'Fall Only', :from => 'Exchange term'
      fill_in 'Student email', with: 'FooBar@gmail.com'
      select 'Smith, John', :from => 'Representative'
      click_on 'Create Student'
    visit new_representative_path
      select 'AM', :from => 'University'
      fill_in 'First name', with: 'Jackie'
      fill_in 'Last name', with: 'Garcia'
      fill_in 'Title', with: 'Director'
      fill_in 'Rep email', with: 'JackieGarcia@yahoo.com'
      click_on 'Create Representative'
    visit new_student_path
      select 'AM', :from => 'University'
      fill_in 'First name', with: 'Test'
      fill_in 'Last name', with: 'Two'
      select 'Bachelors', :from => 'Degree level'
      fill_in 'Major', with: 'Basket Making'
      select 'Fall Only', :from => 'Exchange term'
      fill_in 'Student email', with: 'FooBar@gmail.com'
      select 'Garcia, Jackie', :from => 'Representative'
      click_on 'Create Student'
    visit representatives_path
    click_on 'Clear All'
      click_on 'Clear All Representatives'
    visit universities_path
      expect(page).to have_content('AM 0 3')
    visit representatives_path
      expect(page).not_to have_content('John')
      expect(page).not_to have_content('Jackie')
    visit students_path
      expect(page).not_to have_content('Foo')
      expect(page).not_to have_content('Test')
  end
end

RSpec.describe 'Admin student functions', type: :feature do
  before do
    @authorized = Authorized.create(authorized_email: "userdoe@example.com")
    Rails.application.env_config['devise.mapping'] = Devise.mappings[:admin]
    Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google_user]
    unless Admin.where(email: 'userdoe@example.com').first.nil? == false
      Admin.create!(email: 'userdoe@example.com', full_name: 'User Doe', uid: '123456789', avatar_url: 'https://lh3.googleusercontent.com/url/photo.jpg')
    end
    visit root_path
    click_on 'Admin login'
    visit new_university_path
      fill_in 'University name', with: 'AM'
      click_on 'Create University'
    visit new_representative_path
      select 'AM', :from => 'University'
      fill_in 'First name', with: 'John'
      fill_in 'Last name', with: 'Smith'
      fill_in 'Title', with: 'CEO'
      fill_in 'Rep email', with: 'JohnSmith@gmail.com'
      click_on 'Create Representative'
  end

  # new/create
  scenario 'create student' do
    visit new_student_path
      click_on 'Create Student'
      expect(page).to have_content('error')
      select 'AM', :from => 'University'
      select 'Smith, John', :from => 'Representative'
      fill_in 'First name', with: 'Foo'
      fill_in 'Last name', with: 'Bar'
      select 'Bachelors', :from => 'Degree level'
      fill_in 'Major', with: 'Basket Making'
      select 'Fall Only', :from => 'Exchange term'
      fill_in 'Student email', with: 'FooBar@gmail.com'
      click_on 'Create Student'
    visit new_student_path
      select 'AM', :from => 'University'
      fill_in 'First name', with: 'Test'
      fill_in 'Last name', with: 'Two'
      select 'Bachelors', :from => 'Degree level'
      fill_in 'Major', with: 'Basket Making'
      select 'Fall and Spring', :from => 'Exchange term'
      fill_in 'Student email', with: 'TT@gmail.com'
      select 'Smith, John', :from => 'Representative'
      click_on 'Create Student'
    visit students_path
      expect(page).to have_content('Foo')
      expect(page).to have_content('Bar')
      expect(page).to have_content('AM')
      expect(page).to have_content('John Smith')
      expect(page).to have_content('Bachelors')
      expect(page).to have_content('Basket Making')
      expect(page).to have_content('Fall Only')
      expect(page).to have_content('FooBar@gmail.com')
  end

  # edit/update
  scenario 'editing a student' do
    visit new_student_path
      select 'AM', :from => 'University'
      fill_in 'First name', with: 'Foo'
      fill_in 'Last name', with: 'Bar'
      select 'Bachelors', :from => 'Degree level'
      fill_in 'Major', with: 'Basket Making'
      select 'Fall Only', :from => 'Exchange term'
      fill_in 'Student email', with: 'FooBar@gmail.com'
      select 'Smith, John', :from => 'Representative'
      click_on 'Create Student'
      visit students_path
    click_on 'Edit'
      fill_in 'First name', with: ''
      click_on 'Update Student'
      expect(page).to have_content('error')
      fill_in 'First name', with: 'Baz'
      click_on 'Update Student'
    visit students_path
    expect(page).to have_content('Baz')
  end

  # delete/destroy
  scenario 'deleting a student' do #FIXME updates max limit
    visit new_student_path
      select 'AM', :from => 'University'
      fill_in 'First name', with: 'Foo'
      fill_in 'Last name', with: 'Bar'
      select 'Bachelors', :from => 'Degree level'
      fill_in 'Major', with: 'Basket Making'
      select 'Fall Only', :from => 'Exchange term'
      fill_in 'Student email', with: 'FooBar@gmail.com'
      select 'Smith, John', :from => 'Representative'
      click_on 'Create Student'
    visit students_path
    click_on 'Delete'
      click_on 'Delete Student'
      expect(page).not_to have_content('Foo')
  end
  
  scenario 'clear all' do
    visit new_student_path
      select 'AM', :from => 'University'
      fill_in 'First name', with: 'Foo'
      fill_in 'Last name', with: 'Bar'
      select 'Bachelors', :from => 'Degree level'
      fill_in 'Major', with: 'Basket Making'
      select 'Fall Only', :from => 'Exchange term'
      fill_in 'Student email', with: 'FooBar@gmail.com'
      select 'Smith, John', :from => 'Representative'
      click_on 'Create Student'
    visit new_student_path
      select 'AM', :from => 'University'
      fill_in 'First name', with: 'Test'
      fill_in 'Last name', with: 'Two'
      select 'Bachelors', :from => 'Degree level'
      fill_in 'Major', with: 'Basket Making'
      select 'Fall Only', :from => 'Exchange term'
      fill_in 'Student email', with: 'FooBar@gmail.com'
      select 'Smith, John', :from => 'Representative'
      click_on 'Create Student'
    visit students_path
    click_on 'Clear All'
      click_on 'Clear All Students'
    visit universities_path
      expect(page).to have_content('AM 0 3')
    visit representatives_path
      expect(page).to have_content('John')
    visit students_path
      expect(page).not_to have_content('Foo')
      expect(page).not_to have_content('Test')
  end

  scenario 'correct students count from creating and deleting' do
    visit new_student_path
      select 'AM', :from => 'University'
      fill_in 'First name', with: 'Foo'
      fill_in 'Last name', with: 'Bar'
      select 'Bachelors', :from => 'Degree level'
      fill_in 'Major', with: 'Basket Making'
      select 'Fall Only', :from => 'Exchange term'
      fill_in 'Student email', with: 'FooBar@gmail.com'
      select 'Smith, John', :from => 'Representative'
      click_on 'Create Student'
    visit universities_path
      expect(page).to have_content('AM 1 3')
    visit students_path
      click_on 'Delete'
      click_on 'Delete Student'
    visit universities_path
      expect(page).to have_content('AM 0 3')
    visit new_student_path
      select 'AM', :from => 'University'
      fill_in 'First name', with: 'Foo'
      fill_in 'Last name', with: 'Bar'
      select 'Bachelors', :from => 'Degree level'
      fill_in 'Major', with: 'Basket Making'
      select 'Fall and Spring', :from => 'Exchange term'
      fill_in 'Student email', with: 'FooBar@gmail.com'
      select 'Smith, John', :from => 'Representative'
      click_on 'Create Student'
    visit universities_path
      expect(page).to have_content('AM 2 3')
    visit students_path
      click_on 'Delete'
      click_on 'Delete Student'
    visit universities_path
      expect(page).to have_content('AM 0 3')
  end

  scenario 'update exchange term' do
    visit new_student_path
      click_on 'Create Student'
      expect(page).to have_content('error')
      select 'AM', :from => 'University'
      select 'Smith, John', :from => 'Representative'
      fill_in 'First name', with: 'Foo'
      fill_in 'Last name', with: 'Bar'
      select 'Bachelors', :from => 'Degree level'
      fill_in 'Major', with: 'Basket Making'
      select 'Fall Only', :from => 'Exchange term'
      fill_in 'Student email', with: 'FooBar@gmail.com'
      click_on 'Create Student'
    visit universities_path
      expect(page).to have_content('AM 1 3')
    visit students_path
      click_on 'Edit'
      select 'Fall and Spring', :from => 'Exchange term'
      click_on 'Update Student'
    visit universities_path
      expect(page).to have_content('AM 2 3')
    visit students_path
      click_on 'Edit'
      select 'Spring Only', :from => 'Exchange term'
      click_on 'Update Student'
    visit universities_path
      expect(page).to have_content('AM 1 3')
  end

  scenario 'update exchange term max' do
    visit new_student_path
      select 'AM', :from => 'University'
      fill_in 'First name', with: 'Foo'
      fill_in 'Last name', with: 'Bar'
      select 'Bachelors', :from => 'Degree level'
      fill_in 'Major', with: 'Basket Making'
      select 'Fall Only', :from => 'Exchange term'
      fill_in 'Student email', with: 'FooBar@gmail.com'
      select 'Smith, John', :from => 'Representative'
      click_on 'Create Student'
    visit universities_path
      fill_in 'change_lim', with: '1'
      click_on 'Change All Limits'
      expect(page).to have_content('AM 1 1')
    visit students_path
      click_on 'Edit'
      select 'Fall and Spring', :from => 'Exchange term'
      click_on 'Update Student'
      expect(page).to have_content('Sorry')
  end
end


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

  # new/create
  scenario 'create question' do
    visit new_question_path
    expect(page).to have_content('New Question')
      click_on 'Create Question'
      expect(page).to have_content('error')
      fill_in 'Prompt', with: 'frq'
      click_on 'Create Question'
    visit questions_path
      expect(page).to have_content('frq')
    click_on 'Show'
      expect(page).to have_content('frq')
  end

  # edit/update
  scenario 'editing question' do
    visit new_question_path
      fill_in 'Prompt', with: 'frq'
      click_on 'Create Question'
    visit questions_path
    click_on 'Edit'
      fill_in 'Prompt', with: ''
      click_on 'Update Question'
      expect(page).to have_content('error')
      fill_in 'Prompt', with: 'different'
    click_on 'Update Question'
      expect(page).to have_content('different')
  end

  # delete/destroy
  scenario 'deleting question' do
    visit new_question_path
      fill_in 'Prompt', with: 'frq'
      click_on 'Create Question'
    visit questions_path
    click_on 'Delete'
      click_on 'Delete Question'
      expect(page).not_to have_content('frq')
  end

  scenario 'create answer' do
    visit new_question_path
    click_on 'Create Question'
    fill_in 'Prompt', with: 'multi'
	check 'question_multi'
    click_on 'Create Question'
	click_on 'Add Answer'
	click_on 'New Answer'
	fill_in 'Choice', with: '1'
	click_on 'Create Answer'
	expect(page).to have_content('1')
  end
  
  scenario 'edit answer' do
    visit new_question_path
    click_on 'Create Question'
    fill_in 'Prompt', with: 'multi'
	check 'question_multi'
    click_on 'Create Question'
	click_on 'Add Answer'
	click_on 'New Answer'
	fill_in 'Choice', with: '1'
	click_on 'Create Answer'
	click_on 'Edit Choice'
    fill_in 'Choice', with: ''
    click_on 'Update Answer'
    expect(page).to have_content('error')
    fill_in 'Choice', with: '2'
    click_on 'Update Answer'
    expect(page).to have_content('2')
  end
  
  scenario 'delete answer' do
    visit new_question_path
    click_on 'Create Question'
    fill_in 'Prompt', with: 'multi'
	check 'question_multi'
    click_on 'Create Question'
	click_on 'Add Answer'
	click_on 'New Answer'
	fill_in 'Choice', with: '1'
	click_on 'Create Answer'
	click_on 'Delete Choice'
	click_on 'Destroy'
    expect(page).not_to have_content('1')
  end
end

# RSpec.describe 'Admin question functions', type: :feature do
#   before do
#     @authorized = Authorized.create(authorized_email: "userdoe@example.com")
#     Rails.application.env_config['devise.mapping'] = Devise.mappings[:admin]
#     Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google_user]
#     unless Admin.where(email: 'userdoe@example.com').first.nil? == false
#       Admin.create!(email: 'userdoe@example.com', full_name: 'User Doe', uid: '123456789', avatar_url: 'https://lh3.googleusercontent.com/url/photo.jpg')
#     end
#     visit root_path
#     click_on 'Admin login'
#   end
# end


# ################################### user CRUD functions ###########################

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
      visit new_university_path
      fill_in 'University name', with: 'AM'
      click_on 'Create University'
  end

  scenario 'create representative' do
    visit user_new_representatives_path
      click_on 'Create Representative'
      expect(page).to have_content('error')
      select 'AM', :from => 'University'
      fill_in 'First name', with: 'John'
      fill_in 'Last name', with: 'Smith'
      fill_in 'Title', with: 'CEO'
      fill_in 'Rep email', with: 'JohnSmith@gmail.com'
    click_on 'Create Representative'
      expect(page).to have_content('John')
      expect(page).to have_content('Smith')
      expect(page).to have_content('CEO')
      expect(page).to have_content('JohnSmith@gmail.com')
      # expect to go to user_show after fail, Continue instead of Back
      expect(page).to have_content('Continue')
  end

  scenario 'edit representative' do
    visit user_new_representatives_path
      select 'AM', :from => 'University'
      fill_in 'First name', with: 'John'
      fill_in 'Last name', with: 'Smith'
      fill_in 'Title', with: 'CEO'
      fill_in 'Rep email', with: 'JohnSmith@gmail.com'
      click_on 'Create Representative'
    click_on 'Edit'
      fill_in 'First name', with: ''
      click_on 'Update Representative'
      expect(page).to have_content('error')
      fill_in 'First name', with: 'Alice'
    click_on 'Update Representative'
      expect(page).to have_content('Alice')
      expect(page).to have_content('Continue') # expect user_show
  end
  
  scenario 'finish link' do
    visit user_new_representatives_path
      select 'AM', :from => 'University'
      fill_in 'First name', with: 'John'
      fill_in 'Last name', with: 'Smith'
      fill_in 'Title', with: 'CEO'
      fill_in 'Rep email', with: 'JohnSmith@gmail.com'
      click_on 'Create Representative'
    click_link 'Continue'
      expect(page).to have_content('Nomination Record')
      expect(page).to have_content('John')
      expect(page).to have_content('Smith')
      expect(page).to have_content('CEO')
      expect(page).to have_content('JohnSmith@gmail.com')
  end
end

RSpec.describe 'User student functions', type: :feature do
  before do
    @authorized = Authorized.create(authorized_email: "userdoe@example.com")
    Rails.application.env_config['devise.mapping'] = Devise.mappings[:admin]
    Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google_user]
    unless Admin.where(email: 'userdoe@example.com').first.nil? == false
      Admin.create!(email: 'userdoe@example.com', full_name: 'User Doe', uid: '123456789', avatar_url: 'https://lh3.googleusercontent.com/url/photo.jpg')
    end
    visit root_path # need to create university and representative first
      click_on 'Admin login'
      visit new_university_path
      fill_in 'University name', with: 'AM'
      click_on 'Create University'
    visit user_new_representatives_path
      select 'AM', :from => 'University'
      fill_in 'First name', with: 'John'
      fill_in 'Last name', with: 'Smith'
      fill_in 'Title', with: 'CEO'
      fill_in 'Rep email', with: 'JohnSmith@gmail.com'
      click_on 'Create Representative'
      click_link 'Continue'
  end

  scenario 'create student' do
    expect(page).to have_content('Nomination Record')
    click_on 'Enter a new student'
      expect(page).not_to have_content('University') # can't fill in representative or university
      expect(page).not_to have_content('Representative')
      click_on 'Create Student'
      expect(page).to have_content('error')
      fill_in 'First name', with: 'Foo'
      fill_in 'Last name', with: 'Bar'
      select 'Bachelors', :from => 'Degree level'
      fill_in 'Major', with: 'Basket Making'
      select 'Fall Only', :from => 'Exchange term'
      fill_in 'Student email', with: 'FooBar@gmail.com'
    click_on 'Create Student'
      expect(page).to have_content('Foo')
      expect(page).to have_content('Bar')
      expect(page).to have_content('Bachelors')
      expect(page).to have_content('Basket Making')
      expect(page).to have_content('Fall Only')
      expect(page).to have_content('FooBar@gmail.com')
      expect(page).to have_content('Finish') # expect user_show    
  end

  scenario 'edit student' do
    click_on 'Enter a new student'
      fill_in 'First name', with: 'Foo'
      fill_in 'Last name', with: 'Bar'
      select 'Bachelors', :from => 'Degree level'
      fill_in 'Major', with: 'Basket Making'
      select 'Fall Only', :from => 'Exchange term'
      fill_in 'Student email', with: 'FooBar@gmail.com'
      click_on 'Create Student'
    click_on 'Edit'
      fill_in 'First name', with: ''
      click_on 'Update Student'
      expect(page).to have_content('error')
      fill_in 'First name', with: 'Baz'
    click_on 'Update Student'
      expect(page).to have_content('Baz')
      expect(page).to have_content('Finish') # expect user_show
  end

  scenario 'finish link' do
    click_on 'Enter a new student'
      fill_in 'First name', with: 'Foo'
      fill_in 'Last name', with: 'Bar'
      select 'Bachelors', :from => 'Degree level'
      fill_in 'Major', with: 'Basket Making'
      select 'Fall Only', :from => 'Exchange term'
      fill_in 'Student email', with: 'FooBar@gmail.com'
      click_on 'Create Student'
    click_on 'Finish'
      expect(page).to have_content('Nomination Record')
  end
  
  scenario 'update exchange term up' do
    click_on 'Enter a new student'
      click_on 'Create Student'
      fill_in 'First name', with: 'Foo'
      fill_in 'Last name', with: 'Bar'
      select 'Bachelors', :from => 'Degree level'
      fill_in 'Major', with: 'Basket Making'
      select 'Fall Only', :from => 'Exchange term'
      fill_in 'Student email', with: 'FooBar@gmail.com'
      click_on 'Create Student'
    click_on 'Edit'
      select 'Fall and Spring', :from => 'Exchange term'
      click_on 'Update Student'
    visit universities_path
      expect(page).to have_content('AM 2 3')
  end
  
  scenario 'update exchange term down' do
    click_on 'Enter a new student'
      click_on 'Create Student'
      fill_in 'First name', with: 'Foo'
      fill_in 'Last name', with: 'Bar'
      select 'Bachelors', :from => 'Degree level'
      fill_in 'Major', with: 'Basket Making'
      select 'Fall and Spring', :from => 'Exchange term'
      fill_in 'Student email', with: 'FooBar@gmail.com'
      click_on 'Create Student'
    click_on 'Edit'
      select 'Spring Only', :from => 'Exchange term'
      click_on 'Update Student'
    visit universities_path
      expect(page).to have_content('AM 1 3')
  end

  scenario 'update exchange term max' do
    visit universities_path
      fill_in 'change_lim', with: '1'
      click_on 'Change All Limits'
    visit user_new_representatives_path
      select 'AM', :from => 'University'
      fill_in 'First name', with: 'Johnny'
      fill_in 'Last name', with: 'Smith'
      fill_in 'Title', with: 'CEO'
      fill_in 'Rep email', with: 'JohnnySmith@gmail.com'
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
    click_on 'Edit'
      select 'Fall and Spring', :from => 'Exchange term'
      click_on 'Update Student'
      expect(page).to have_content('Sorry')
  end

  scenario 'delete student' do
    click_on 'Enter a new student'
      fill_in 'First name', with: 'Foo'
      fill_in 'Last name', with: 'Bar'
      select 'Bachelors', :from => 'Degree level'
      fill_in 'Major', with: 'Basket Making'
      select 'Fall Only', :from => 'Exchange term'
      fill_in 'Student email', with: 'FooBar@gmail.com'
      click_on 'Create Student'
    click_on 'Finish'
      click_on 'Delete'
      click_on 'Delete Student'
      expect(page).to have_content('Nomination Record')
      expect(page).not_to have_content('Foo')
  end

  # max limit testing
  scenario 'auto-stop user adding students' do
    expect(page).to have_content('0 students nominated')
    click_on 'Enter a new student' # student 1
      fill_in 'First name', with: 'Foo'
      fill_in 'Last name', with: 'Bar'
      select 'Bachelors', :from => 'Degree level'
      fill_in 'Major', with: 'Basket Making'
      select 'Fall Only', :from => 'Exchange term'
      fill_in 'Student email', with: 'FooBar@gmail.com'
      click_on 'Create Student'
      expect(page).to have_content('1 out of 3')
    click_on 'Enter another new student' # student 2
      fill_in 'First name', with: 'Foo2'
      fill_in 'Last name', with: 'Bar'
      select 'Bachelors', :from => 'Degree level'
      fill_in 'Major', with: 'Basket Making'
      select 'Fall and Spring', :from => 'Exchange term'
      fill_in 'Student email', with: 'Foo2Bar@gmail.com'
      click_on 'Create Student'
      expect(page).to have_content('3 out of 3')
      expect(page).not_to have_content('Enter another new student')
    click_on 'Finish'
      expect(page).to have_content('Nomination Record')
      expect(page).to have_content('3 students nominated')
      expect(page).not_to have_content('Enter another new student')
  end

  scenario "Don't allow more representatives to make nominations after reaching limit" do
    click_on 'Enter a new student' # student 1
      fill_in 'First name', with: 'Foo'
      fill_in 'Last name', with: 'Bar'
      select 'Bachelors', :from => 'Degree level'
      fill_in 'Major', with: 'Basket Making'
      select 'Fall Only', :from => 'Exchange term'
      fill_in 'Student email', with: 'FooBar@gmail.com'
      click_on 'Create Student'
    click_on 'Enter another new student' # student 2
      fill_in 'First name', with: 'Foo2'
      fill_in 'Last name', with: 'Bar'
      select 'Bachelors', :from => 'Degree level'
      fill_in 'Major', with: 'Basket Making'
      select 'Fall Only', :from => 'Exchange term'
      fill_in 'Student email', with: 'Foo2Bar@gmail.com'
      click_on 'Create Student'
    click_on 'Enter another new student' # student 3
      fill_in 'First name', with: 'Foo3'
      fill_in 'Last name', with: 'Bar'
      select 'Bachelors', :from => 'Degree level'
      fill_in 'Major', with: 'Basket Making'
      select 'Fall Only', :from => 'Exchange term'
      fill_in 'Student email', with: 'Foo3Bar@gmail.com'
      click_on 'Create Student'
      # start over with new representative
    visit user_new_representatives_path
      select 'AM', :from => 'University'
      fill_in 'First name', with: 'Alice'
      fill_in 'Last name', with: 'May'
      fill_in 'Title', with: 'Division Head'
      fill_in 'Rep email', with: 'A.May@gmail.com'
      click_on 'Create Representative'
    click_link 'Continue'
      expect(page).to have_content('Nomination Record')
      expect(page).to have_content('3 students nominated')
      expect(page).to have_content('Alice')
      expect(page).not_to have_content('Foo')
      expect(page).not_to have_content('Enter a new student')
  end
end

RSpec.describe 'Deadline', type: :feature do
  before do
    @authorized = Authorized.create(authorized_email: "userdoe@example.com")
    Rails.application.env_config['devise.mapping'] = Devise.mappings[:admin]
    Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google_user]
    unless Admin.where(email: 'userdoe@example.com').first.nil? == false
      Admin.create!(email: 'userdoe@example.com', full_name: 'User Doe', uid: '123456789', avatar_url: 'https://lh3.googleusercontent.com/url/photo.jpg')
    end
    visit root_path # need to create university and representative first
      click_on 'Admin login'
      visit new_university_path
      fill_in 'University name', with: 'AM'
      click_on 'Create University'
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
    visit admin_path
      fill_in 'deadline', with: DateTime.current.prev_day(1)
      click_on 'Update Deadline'
  end

  scenario 'root redirect' do
    visit user_new_representatives_path
    expect(page).to have_content('The deadline for this form has passed')
  end

  scenario 'create representitive' do
    visit admin_path
      fill_in 'deadline', with: DateTime.current + 3.seconds
      click_on 'Update Deadline'
    visit root_path
      select 'AM', :from => 'University'
      fill_in 'First name', with: 'John'
      fill_in 'Last name', with: 'Smith'
      fill_in 'Title', with: 'CEO'
      fill_in 'Rep email', with: 'JohnSmith@gmail.com'
      sleep(3)
      click_on 'Create Representative'
      expect(page).to have_content('The deadline for this form has passed')
  end

  scenario 'create student' do
    visit user_new_student_path(Representative.all[0])
      expect(page).not_to have_content('University') # can't fill in representative or university
      expect(page).not_to have_content('Representative')
      fill_in 'First name', with: 'Foo2'
      fill_in 'Last name', with: 'Bar2'
      select 'Bachelors', :from => 'Degree level'
      fill_in 'Major', with: 'Basket Making'
      select 'Fall Only', :from => 'Exchange term'
      fill_in 'Student email', with: 'FooBar@gmail.com'
    click_on 'Create Student'
      expect(page).not_to have_content('Foo2')
      expect(page).not_to have_content('Bar2') 
  end

  scenario 'edit student' do
    visit user_edit_student_url(Student.all[0])
      fill_in 'First name', with: 'Baz'
    click_on 'Update Student'
      expect(page).not_to have_content('Baz')
  end

  scenario 'delete student' do
    visit user_delete_student_url(Student.all[0])
      click_on 'Delete Student'
      expect(page).to have_content('Nomination Record')
      expect(page).to have_content('Foo')
  end
end

RSpec.describe 'User Question functions', type: :feature do
  before do
    @authorized = Authorized.create(authorized_email: "userdoe@example.com")
    Rails.application.env_config['devise.mapping'] = Devise.mappings[:admin]
    Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google_user]
    unless Admin.where(email: 'userdoe@example.com').first.nil? == false
      Admin.create!(email: 'userdoe@example.com', full_name: 'User Doe', uid: '123456789', avatar_url: 'https://lh3.googleusercontent.com/url/photo.jpg')
    end
      visit root_path # need to create university first
      click_on 'Admin login'
      visit new_university_path
      fill_in 'University name', with: 'AM'
      click_on 'Create University'
	  
	  visit new_question_path
	  fill_in 'Prompt', with: 'How are you?'
	  click_on 'Create Question'
	  
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
  end
  
  scenario 'User can view Questions' do
	  expect(page).to have_content('How are you?')
  end
  
  scenario 'Answer FRQ Question' do
	  click_on 'Edit Answer'
      fill_in 'How are you?', with: 'Good'
      click_on 'Update Response'
      expect(page).to have_content('Good')
  end
end


RSpec.describe 'User Answer functions', type: :feature do
  before do
    @authorized = Authorized.create(authorized_email: "userdoe@example.com")
    Rails.application.env_config['devise.mapping'] = Devise.mappings[:admin]
    Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google_user]
    unless Admin.where(email: 'userdoe@example.com').first.nil? == false
      Admin.create!(email: 'userdoe@example.com', full_name: 'User Doe', uid: '123456789', avatar_url: 'https://lh3.googleusercontent.com/url/photo.jpg')
    end
      visit root_path # need to create university first
      click_on 'Admin login'
      visit new_university_path
      fill_in 'University name', with: 'AM'
      click_on 'Create University'

	  visit new_question_path
	  check 'question_multi'
	  fill_in 'Prompt', with: 'Yes or no?'
	  click_on 'Create Question'
	  
	  click_on 'Add Answer'
	  click_on 'New Answer'
	  fill_in 'Choice', with: 'Yes'
	  click_on 'Create Answer'
	  click_on 'New Answer'
	  fill_in 'Choice', with: 'No'
	  click_on 'Create Answer'
	  
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
  end
  
  scenario 'User can view Questions' do
      expect(page).to have_content('Yes or no?')
  end

  scenario 'Answer Multiple Choice Question' do
	  click_on 'Edit Answer'
      select 'Yes', :from => 'Yes or no?'
      click_on 'Update Response'
      expect(page).to have_content('Yes')
  end
end

#test destroy associations
#test show compound tables?
#valid email