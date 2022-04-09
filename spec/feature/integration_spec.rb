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

  # FIXME responses?
  # not including deadline or export here

  scenario 'Return link' do
    visit admin_path
    click_on 'Return to Home Page'
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
  #FIXME check links
  #check destroy association

  # max update
  scenario 'update default max limit' do 
    visit universities_path
      expect(page).to have_content('3')
      fill_in 'max_lim', with: '-1'
      click_on 'Update Default Limit'
      expect(page).to have_content('cannot be negative')
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
      fill_in 'change_lim', with: '5'
    click_on 'Change All Limits'
      expect(page).to have_content('AM 0 5')
      expect(page).to have_content('TU 0 5')
      expect(page).to have_content('successful')
  end
  #clear all, reset all
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
  #FIXME check links
  #check destroy association
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
  end

  # new/create
  scenario 'create student' do
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
    visit students_path
    click_on 'Delete'
      click_on 'Delete Student'
      expect(page).not_to have_content('Foo')
  end
  #FIXME check links
  #check destroy association
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
      select 'Fall Only', :from => 'Exchange term'
      fill_in 'Student email', with: 'Foo2Bar@gmail.com'
      click_on 'Create Student'
      expect(page).to have_content('2 out of 3')
    click_on 'Enter another new student' # student 3
      fill_in 'First name', with: 'Foo3'
      fill_in 'Last name', with: 'Bar'
      select 'Bachelors', :from => 'Degree level'
      fill_in 'Major', with: 'Basket Making'
      select 'Fall Only', :from => 'Exchange term'
      fill_in 'Student email', with: 'Foo3Bar@gmail.com'
      click_on 'Create Student'
      expect(page).to have_content('3 out of 3')
    click_on 'Enter another new student' # auto-redirect to finish page
      expect(page).to have_content('Nomination Record')
      expect(page).to have_content('Sorry')
      expect(page).to have_content('3 students nominated')
    click_on 'Enter a new student' # should not redirect
      expect(page).to have_content('Nomination Record')
      expect(page).to have_content('Sorry')
      expect(page).to have_content('3 students nominated')
  end

  scenario 'Re-activate new students after delete' do
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
    click_on 'Enter another new student' # auto-redirect to finish page
      expect(page).to have_content('3 students nominated')
    click_on 'Delete'
      click_on 'Delete Student'
      expect(page).to have_content('2 students nominated')
    click_on 'Enter a new student' # should redirect now
      expect(page).to have_content('New Student')
  end

  scenario "don't allow more representatives to make nominations after reaching limit" do
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
      click_on 'Enter a new student'
        expect(page).not_to have_content('New Student')
        expect(page).to have_content('Nomination Record')
        expect(page).to have_content('Sorry')
    end
end

#test destroy associations
#test show compound tables?
#valid email
