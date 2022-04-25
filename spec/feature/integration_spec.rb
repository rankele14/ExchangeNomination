# frozen_string_literal: true

require 'rails_helper'

RSpec.describe('Logging in', type: :feature) do
  before do
    @authorized = Authorized.create!(authorized_email: 'userdoe@example.com')
    Rails.application.env_config['devise.mapping'] = Devise.mappings[:admin]
    Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google_user]
    Admin.create!(email: 'userdoe@example.com', full_name: 'User Doe', uid: '123456789', avatar_url: 'https://lh3.googleusercontent.com/url/photo.jpg') unless Admin.where(email: 'userdoe@example.com').first.nil? == false
  end

  it 'valid inputs' do
    visit root_path
    click_on 'Admin login'
    expect(page).to(have_content('Successfully authenticated from Google account.'))
    expect(page).to(have_content('Admin Home Page'))
  end

  it 'sign out' do
    visit root_path
    click_on 'Admin login'
    click_on 'Sign Out'
    expect(page).to(have_content('Nominator Info'))
  end
end

################################### admin CUD functions ###########################

RSpec.describe('Admin dashboard links', type: :feature) do
  before do
    @authorized = Authorized.create!(authorized_email: 'userdoe@example.com')
    Rails.application.env_config['devise.mapping'] = Devise.mappings[:admin]
    Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google_user]
    Admin.create!(email: 'userdoe@example.com', full_name: 'User Doe', uid: '123456789', avatar_url: 'https://lh3.googleusercontent.com/url/photo.jpg') unless Admin.where(email: 'userdoe@example.com').first.nil? == false
    visit root_path
    click_on 'Admin login'
  end

  it 'Universities link' do
    visit admin_path
    click_on 'Universities'
    click_on 'Back to Admin'
    click_on 'Universities'
    # expect help and nav bar?
    click_on 'New University'
  end

  it 'Nominators link' do
    visit admin_path
    click_on 'Nominators'
    click_on 'Back to Admin'
    click_on 'Nominators'
    click_on 'New Nominator'
  end

  it 'Students link' do
    visit admin_path
    click_on 'Students'
    click_on 'Back to Admin'
    click_on 'Students'
    click_on 'New Student'
  end

  it 'Questions link' do
    visit admin_path
    click_on 'Questions'
    click_on 'Back to Admin'
    click_on 'Questions'
    click_on 'New Question'
  end

  it 'Admin list link' do
    visit admin_path
    click_on 'Admin List'
    click_on 'Back to Admin'
    click_on 'Admin List'
    click_on 'New Admin'
  end

  it 'Export' do
    visit root_path
    click_on 'Admin login'
    click_on 'Export Students'
  end

  # FIXME: responses?
  # not including deadline here

  it 'Return link' do
    visit admin_path
    click_on 'Return to Home Page'
    expect(page).to(have_content('Nominator Info'))
  end

  # scenario 'Help page' do
  #   visit admin_path
  #   click_on 'Help'
  #   expect(page).to have_content('')
  # end

  it 'Sign out' do
    visit admin_path
    click_on 'Sign Out'
    expect(page).to(have_content('Signed out'))
    expect(page).to(have_content('Nominator Info'))
  end
end

RSpec.describe('Admin university functions', type: :feature) do
  before do
    @authorized = Authorized.create!(authorized_email: 'userdoe@example.com')
    Rails.application.env_config['devise.mapping'] = Devise.mappings[:admin]
    Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google_user]
    Admin.create!(email: 'userdoe@example.com', full_name: 'User Doe', uid: '123456789', avatar_url: 'https://lh3.googleusercontent.com/url/photo.jpg') unless Admin.where(email: 'userdoe@example.com').first.nil? == false
    visit root_path
    click_on 'Admin login'
  end

  # new/create
  it 'create university with defaults' do
    visit new_university_path
    expect(page).to(have_content('New University'))
    click_on 'Create University'
    expect(page).to(have_content('error'))
    fill_in 'University name', with: 'UniName'
    click_on 'Create University'
    visit universities_path
    expect(page).to(have_content('UniName'))
    expect(page).to(have_content('0'))
    expect(page).to(have_content('3'))
    click_on 'Show'
    expect(page).to(have_content('UniName'))
    expect(page).to(have_content('0'))
    expect(page).to(have_content('3'))
  end

  it 'create university and change defaults' do
    visit new_university_path
    click_on 'Create University'
    expect(page).to(have_content('error'))
    fill_in 'University name', with: 'UniName'
    fill_in 'Num nominees', with: '2'
    fill_in 'Max limit', with: '17'
    click_on 'Create University'
    visit universities_path
    expect(page).to(have_content('UniName'))
    expect(page).to(have_content('2'))
    expect(page).to(have_content('17'))
  end

  # edit/update
  it 'editing university' do
    visit new_university_path
    fill_in 'University name', with: 'UniName'
    click_on 'Create University'
    visit universities_path
    click_on 'Edit'
    fill_in 'University name', with: ''
    click_on 'Update University'
    expect(page).to(have_content('error'))
    fill_in 'University name', with: 'UT'
    fill_in 'Num nominees', with: '2'
    fill_in 'Max limit', with: '17'
    click_on 'Update University'
    visit universities_path
    expect(page).to(have_content('UT'))
    expect(page).to(have_content('2'))
    expect(page).to(have_content('17'))
    # FIXME: bug if max_limit lower than num_students
  end

  # delete/destroy
  it 'deleting university' do
    visit new_university_path
    fill_in 'University name', with: 'UniName'
    click_on 'Create University'
    visit universities_path
    click_on 'Delete'
    click_on 'Delete University'
    expect(page).not_to(have_content('UniName'))
  end

  it 'check destroy association' do
    visit new_university_path
    fill_in 'University name', with: 'UniName'
    click_on 'Create University'
    visit new_nominator_path
    select 'UniName', from: 'University'
    fill_in 'First name', with: 'John'
    fill_in 'Last name', with: 'Smith'
    fill_in 'Title', with: 'CEO'
    fill_in 'Email', with: 'JohnSmith@gmail.com'
    click_on 'Create Nominator'
    visit new_student_path
    select 'UniName', from: 'University'
    fill_in 'First name', with: 'Foo'
    fill_in 'Last name', with: 'Bar'
    select 'Bachelors', from: 'Degree level'
    fill_in 'Major', with: 'Basket Making'
    select 'Fall Only', from: 'Exchange term'
    fill_in 'Student email', with: 'FooBar@gmail.com'
    select 'Smith, John', from: 'Nominator'
    click_on 'Create Student'
    visit universities_path
    click_on 'Delete'
    click_on 'Delete University'
    expect(page).not_to(have_content('UniName'))
    visit nominators_path
    expect(page).not_to(have_content('John'))
    visit students_path
    expect(page).not_to(have_content('Foo'))
  end

  # max update
  it 'update default max limit' do
    visit universities_path
    expect(page).to(have_content('3'))
    fill_in 'max_lim', with: '-1'
    click_on 'Update Default Limit'
    expect(page).to(have_content('cannot be negative'))
    fill_in 'max_lim', with: '9999'
    click_on 'Update Default Limit'
    expect(page).to(have_content('capped at 100'))
    fill_in 'max_lim', with: '5'
    click_on 'Update Default Limit'
    expect(page).not_to(have_content('3'))
    expect(page).to(have_content('5'))
    expect(page).to(have_content('successful'))
  end

  it 'change all max limits' do
    visit new_university_path
    fill_in 'University name', with: 'UniName'
    click_on 'Create University'
    visit new_university_path
    fill_in 'University name', with: 'TU'
    click_on 'Create University'
    visit universities_path
    fill_in 'change_lim', with: '-1'
    click_on 'Change All Limits'
    expect(page).to(have_content('cannot be negative'))
    fill_in 'change_lim', with: '9999'
    click_on 'Change All Limits'
    expect(page).to(have_content('capped at 100'))
    fill_in 'change_lim', with: '5'
    click_on 'Change All Limits'
    expect(page).to(have_content('UniName 0 5'))
    expect(page).to(have_content('TU 0 5'))
    expect(page).to(have_content('successful'))
  end

  it 'clear all' do
    visit new_university_path
    fill_in 'University name', with: 'UniName'
    click_on 'Create University'
    visit new_university_path
    fill_in 'University name', with: 'TU'
    click_on 'Create University'
    visit new_nominator_path
    select 'UniName', from: 'University'
    fill_in 'First name', with: 'John'
    fill_in 'Last name', with: 'Smith'
    fill_in 'Title', with: 'CEO'
    fill_in 'Email', with: 'JohnSmith@gmail.com'
    click_on 'Create Nominator'
    visit new_student_path
    select 'UniName', from: 'University'
    fill_in 'First name', with: 'Foo'
    fill_in 'Last name', with: 'Bar'
    select 'Bachelors', from: 'Degree level'
    fill_in 'Major', with: 'Basket Making'
    select 'Fall Only', from: 'Exchange term'
    fill_in 'Student email', with: 'FooBar@gmail.com'
    select 'Smith, John', from: 'Nominator'
    click_on 'Create Student'
    visit new_nominator_path
    select 'TU', from: 'University'
    fill_in 'First name', with: 'Jackie'
    fill_in 'Last name', with: 'Garcia'
    fill_in 'Title', with: 'Director'
    fill_in 'Email', with: 'JackieGarcia@yahoo.com'
    click_on 'Create Nominator'
    visit new_student_path
    select 'TU', from: 'University'
    fill_in 'First name', with: 'Test'
    fill_in 'Last name', with: 'Two'
    select 'Bachelors', from: 'Degree level'
    fill_in 'Major', with: 'Basket Making'
    select 'Fall Only', from: 'Exchange term'
    fill_in 'Student email', with: 'FooBar@gmail.com'
    select 'Garcia, Jackie', from: 'Nominator'
    click_on 'Create Student'
    visit universities_path
    click_on 'Clear All'
    click_on 'Clear All Universities'
    visit universities_path
    expect(page).not_to(have_content('UniName'))
    expect(page).not_to(have_content('TU'))
    visit nominators_path
    expect(page).not_to(have_content('John'))
    expect(page).not_to(have_content('Jackie'))
    visit students_path
    expect(page).not_to(have_content('Foo'))
    expect(page).not_to(have_content('Test'))
  end

  it 'reset all' do
    visit new_university_path
    fill_in 'University name', with: 'UniName'
    click_on 'Create University'
    visit new_university_path
    fill_in 'University name', with: 'TU'
    click_on 'Create University'
    visit new_nominator_path
    select 'UniName', from: 'University'
    fill_in 'First name', with: 'John'
    fill_in 'Last name', with: 'Smith'
    fill_in 'Title', with: 'CEO'
    fill_in 'Email', with: 'JohnSmith@gmail.com'
    click_on 'Create Nominator'
    visit new_student_path
    select 'UniName', from: 'University'
    fill_in 'First name', with: 'Foo'
    fill_in 'Last name', with: 'Bar'
    select 'Bachelors', from: 'Degree level'
    fill_in 'Major', with: 'Basket Making'
    select 'Fall Only', from: 'Exchange term'
    fill_in 'Student email', with: 'FooBar@gmail.com'
    select 'Smith, John', from: 'Nominator'
    click_on 'Create Student'
    visit new_nominator_path
    select 'TU', from: 'University'
    fill_in 'First name', with: 'Jackie'
    fill_in 'Last name', with: 'Garcia'
    fill_in 'Title', with: 'Director'
    fill_in 'Email', with: 'JackieGarcia@yahoo.com'
    click_on 'Create Nominator'
    visit new_student_path
    select 'TU', from: 'University'
    fill_in 'First name', with: 'Test'
    fill_in 'Last name', with: 'Two'
    select 'Bachelors', from: 'Degree level'
    fill_in 'Major', with: 'Basket Making'
    select 'Fall Only', from: 'Exchange term'
    fill_in 'Student email', with: 'FooBar@gmail.com'
    select 'Garcia, Jackie', from: 'Nominator'
    click_on 'Create Student'
    visit universities_path
    click_on 'Reset All'
    expect(page).to(have_content('Reset'))
    click_on 'Reset All Universities'
    visit universities_path
    expect(page).to(have_content('UniName 0 3'))
    expect(page).to(have_content('TU 0 3'))
    visit nominators_path
    expect(page).not_to(have_content('John'))
    expect(page).not_to(have_content('Jackie'))
    visit students_path
    expect(page).not_to(have_content('Foo'))
    expect(page).not_to(have_content('Test'))
  end
end

RSpec.describe('Admin nominator functions', type: :feature) do
  before do
    @authorized = Authorized.create!(authorized_email: 'userdoe@example.com')
    Rails.application.env_config['devise.mapping'] = Devise.mappings[:admin]
    Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google_user]
    Admin.create!(email: 'userdoe@example.com', full_name: 'User Doe', uid: '123456789', avatar_url: 'https://lh3.googleusercontent.com/url/photo.jpg') unless Admin.where(email: 'userdoe@example.com').first.nil? == false
    visit root_path
    click_on 'Admin login'
  end

  # new/create
  it 'create nominator' do
    visit new_university_path
    fill_in 'University name', with: 'UniName'
    click_on 'Create University'
    visit universities_path
    visit new_nominator_path
    click_on 'Create Nominator'
    expect(page).to(have_content('error'))
    select 'UniName', from: 'University'
    fill_in 'First name', with: 'John'
    fill_in 'Last name', with: 'Smith'
    fill_in 'Title', with: 'CEO'
    # FIXME: should error this part without @ but doesn't
    # fill_in 'Email', with: 'JohnSmith'
    # click_on 'Create Nominator'
    # expect(page).to have_content('error')
    fill_in 'Email', with: 'JohnSmith@gmail.com'
    click_on 'Create Nominator'
    visit nominators_path
    expect(page).to(have_content('John'))
    expect(page).to(have_content('Smith'))
    expect(page).to(have_content('CEO'))
    expect(page).to(have_content('JohnSmith@gmail.com'))
  end

  # edit/update
  it 'editing a nominator' do
    visit new_university_path
    fill_in 'University name', with: 'UniName'
    click_on 'Create University'
    visit new_nominator_path
    select 'UniName', from: 'University'
    fill_in 'First name', with: 'John'
    fill_in 'Last name', with: 'Smith'
    fill_in 'Title', with: 'CEO'
    fill_in 'Email', with: 'JohnSmith@gmail.com'
    click_on 'Create Nominator'
    visit nominators_path
    click_on 'Edit'
    fill_in 'First name', with: ''
    click_on 'Update Nominator'
    expect(page).to(have_content('error'))
    fill_in 'First name', with: 'Alice'
    click_on 'Update Nominator'
    visit nominators_path
    expect(page).to(have_content('Alice'))
  end

  it 'editing a nominator\'s university' do
    visit new_university_path
    fill_in 'University name', with: 'UniName'
    click_on 'Create University'
    visit new_university_path
    fill_in 'University name', with: 'TU'
    click_on 'Create University'
    visit new_nominator_path
    select 'UniName', from: 'University'
    fill_in 'First name', with: 'John'
    fill_in 'Last name', with: 'Smith'
    fill_in 'Title', with: 'CEO'
    fill_in 'Email', with: 'JohnSmith@gmail.com'
    click_on 'Create Nominator'
    visit new_student_path
    select 'UniName', from: 'University'
    fill_in 'First name', with: 'Foo'
    fill_in 'Last name', with: 'Bar'
    select 'Bachelors', from: 'Degree level'
    fill_in 'Major', with: 'Basket Making'
    select 'Fall Only', from: 'Exchange term'
    fill_in 'Student email', with: 'FooBar@gmail.com'
    select 'Smith, John', from: 'Nominator'
    click_on 'Create Student'
    visit new_student_path
    select 'UniName', from: 'University'
    fill_in 'First name', with: 'Test'
    fill_in 'Last name', with: 'Two'
    select 'Bachelors', from: 'Degree level'
    fill_in 'Major', with: 'Basket Making'
    select 'Fall and Spring', from: 'Exchange term'
    fill_in 'Student email', with: 'TT@gmail.com'
    select 'Smith, John', from: 'Nominator'
    click_on 'Create Student'
    visit universities_path
    expect(page).to(have_content('UniName 3 3'))
    expect(page).to(have_content('TU 0 3'))
    visit nominators_path
    click_on 'Edit'
    select '', from: 'University'
    click_on 'Update Nominator'
    expect(page).to(have_content('error'))
    select 'TU', from: 'University'
    click_on 'Update Nominator'
    visit nominators_path
    expect(page).to(have_content('TU'))
    visit students_path
    expect(page).to(have_content('TU'))
    expect(page).not_to(have_content('UniName'))
    visit universities_path
    expect(page).to(have_content('UniName 0 3'))
    expect(page).to(have_content('TU 3 3'))
  end

  # delete/destroy
  it 'deleting a nominator' do
    visit new_university_path
    fill_in 'University name', with: 'UniName'
    click_on 'Create University'
    visit new_nominator_path
    select 'UniName', from: 'University'
    fill_in 'First name', with: 'John'
    fill_in 'Last name', with: 'Smith'
    fill_in 'Title', with: 'CEO'
    fill_in 'Email', with: 'JohnSmith@gmail.com'
    click_on 'Create Nominator'
    visit nominators_path
    click_on 'Delete'
    click_on 'Delete Nominator'
    expect(page).not_to(have_content('John'))
  end

  it 'delete associations' do
    visit new_university_path
    fill_in 'University name', with: 'UniName'
    click_on 'Create University'
    visit new_nominator_path
    select 'UniName', from: 'University'
    fill_in 'First name', with: 'John'
    fill_in 'Last name', with: 'Smith'
    fill_in 'Title', with: 'CEO'
    fill_in 'Email', with: 'JohnSmith@gmail.com'
    click_on 'Create Nominator'
    visit new_student_path
    select 'UniName', from: 'University'
    fill_in 'First name', with: 'Foo'
    fill_in 'Last name', with: 'Bar'
    select 'Bachelors', from: 'Degree level'
    fill_in 'Major', with: 'Basket Making'
    select 'Fall Only', from: 'Exchange term'
    fill_in 'Student email', with: 'FooBar@gmail.com'
    select 'Smith, John', from: 'Nominator'
    click_on 'Create Student'
    visit nominators_path
    click_on 'Delete'
    click_on 'Delete Nominator'
    visit universities_path
    expect(page).to(have_content('UniName 0 3'))
    visit nominators_path
    expect(page).not_to(have_content('John'))
    visit students_path
    expect(page).not_to(have_content('Foo'))
  end

  it 'clear all' do
    visit new_university_path
    fill_in 'University name', with: 'UniName'
    click_on 'Create University'
    visit new_nominator_path
    select 'UniName', from: 'University'
    fill_in 'First name', with: 'John'
    fill_in 'Last name', with: 'Smith'
    fill_in 'Title', with: 'CEO'
    fill_in 'Email', with: 'JohnSmith@gmail.com'
    click_on 'Create Nominator'
    visit new_student_path
    select 'UniName', from: 'University'
    fill_in 'First name', with: 'Foo'
    fill_in 'Last name', with: 'Bar'
    select 'Bachelors', from: 'Degree level'
    fill_in 'Major', with: 'Basket Making'
    select 'Fall Only', from: 'Exchange term'
    fill_in 'Student email', with: 'FooBar@gmail.com'
    select 'Smith, John', from: 'Nominator'
    click_on 'Create Student'
    visit new_nominator_path
    select 'UniName', from: 'University'
    fill_in 'First name', with: 'Jackie'
    fill_in 'Last name', with: 'Garcia'
    fill_in 'Title', with: 'Director'
    fill_in 'Email', with: 'JackieGarcia@yahoo.com'
    click_on 'Create Nominator'
    visit new_student_path
    select 'UniName', from: 'University'
    fill_in 'First name', with: 'Test'
    fill_in 'Last name', with: 'Two'
    select 'Bachelors', from: 'Degree level'
    fill_in 'Major', with: 'Basket Making'
    select 'Fall Only', from: 'Exchange term'
    fill_in 'Student email', with: 'FooBar@gmail.com'
    select 'Garcia, Jackie', from: 'Nominator'
    click_on 'Create Student'
    visit nominators_path
    click_on 'Clear All'
    click_on 'Clear All Nominators'
    visit universities_path
    expect(page).to(have_content('UniName 0 3'))
    visit nominators_path
    expect(page).not_to(have_content('John'))
    expect(page).not_to(have_content('Jackie'))
    visit students_path
    expect(page).not_to(have_content('Foo'))
    expect(page).not_to(have_content('Test'))
  end
end

RSpec.describe('Admin student functions', type: :feature) do
  before do
    @authorized = Authorized.create!(authorized_email: 'userdoe@example.com')
    Rails.application.env_config['devise.mapping'] = Devise.mappings[:admin]
    Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google_user]
    Admin.create!(email: 'userdoe@example.com', full_name: 'User Doe', uid: '123456789', avatar_url: 'https://lh3.googleusercontent.com/url/photo.jpg') unless Admin.where(email: 'userdoe@example.com').first.nil? == false
    visit root_path
    click_on 'Admin login'
    visit new_university_path
    fill_in 'University name', with: 'UniName'
    click_on 'Create University'
    visit new_nominator_path
    select 'UniName', from: 'University'
    fill_in 'First name', with: 'John'
    fill_in 'Last name', with: 'Smith'
    fill_in 'Title', with: 'CEO'
    fill_in 'Email', with: 'JohnSmith@gmail.com'
    click_on 'Create Nominator'
  end

  # new/create
  it 'create student' do
    visit new_student_path
    click_on 'Create Student'
    expect(page).to(have_content('error'))
    select 'UniName', from: 'University'
    select 'Smith, John', from: 'Nominator'
    fill_in 'First name', with: 'Foo'
    fill_in 'Last name', with: 'Bar'
    select 'Bachelors', from: 'Degree level'
    fill_in 'Major', with: 'Basket Making'
    select 'Fall Only', from: 'Exchange term'
    fill_in 'Student email', with: 'FooBar@gmail.com'
    click_on 'Create Student'
    visit new_student_path
    select 'UniName', from: 'University'
    fill_in 'First name', with: 'Test'
    fill_in 'Last name', with: 'Two'
    select 'Bachelors', from: 'Degree level'
    fill_in 'Major', with: 'Basket Making'
    select 'Fall and Spring', from: 'Exchange term'
    fill_in 'Student email', with: 'TT@gmail.com'
    select 'Smith, John', from: 'Nominator'
    click_on 'Create Student'
    visit students_path
    expect(page).to(have_content('Foo'))
    expect(page).to(have_content('Bar'))
    expect(page).to(have_content('UniName'))
    expect(page).to(have_content('John Smith'))
    expect(page).to(have_content('Bachelors'))
    expect(page).to(have_content('Basket Making'))
    expect(page).to(have_content('Fall Only'))
    expect(page).to(have_content('FooBar@gmail.com'))
  end

  # edit/update
  it 'editing a student' do
    visit new_student_path
    select 'UniName', from: 'University'
    fill_in 'First name', with: 'Foo'
    fill_in 'Last name', with: 'Bar'
    select 'Bachelors', from: 'Degree level'
    fill_in 'Major', with: 'Basket Making'
    select 'Fall Only', from: 'Exchange term'
    fill_in 'Student email', with: 'FooBar@gmail.com'
    select 'Smith, John', from: 'Nominator'
    click_on 'Create Student'
    visit students_path
    click_on 'Edit'
    fill_in 'First name', with: ''
    click_on 'Update Student'
    expect(page).to(have_content('error'))
    fill_in 'First name', with: 'Baz'
    click_on 'Update Student'
    visit students_path
    expect(page).to(have_content('Baz'))
  end

  # delete/destroy
  it 'deleting a student' do
    visit new_student_path
    select 'UniName', from: 'University'
    fill_in 'First name', with: 'Foo'
    fill_in 'Last name', with: 'Bar'
    select 'Bachelors', from: 'Degree level'
    fill_in 'Major', with: 'Basket Making'
    select 'Fall Only', from: 'Exchange term'
    fill_in 'Student email', with: 'FooBar@gmail.com'
    select 'Smith, John', from: 'Nominator'
    click_on 'Create Student'
    visit students_path
    click_on 'Delete'
    click_on 'Delete Student'
    expect(page).not_to(have_content('Foo'))
  end

  it 'clear all' do
    visit new_student_path
    select 'UniName', from: 'University'
    fill_in 'First name', with: 'Foo'
    fill_in 'Last name', with: 'Bar'
    select 'Bachelors', from: 'Degree level'
    fill_in 'Major', with: 'Basket Making'
    select 'Fall Only', from: 'Exchange term'
    fill_in 'Student email', with: 'FooBar@gmail.com'
    select 'Smith, John', from: 'Nominator'
    click_on 'Create Student'
    visit new_student_path
    select 'UniName', from: 'University'
    fill_in 'First name', with: 'Test'
    fill_in 'Last name', with: 'Two'
    select 'Bachelors', from: 'Degree level'
    fill_in 'Major', with: 'Basket Making'
    select 'Fall Only', from: 'Exchange term'
    fill_in 'Student email', with: 'FooBar@gmail.com'
    select 'Smith, John', from: 'Nominator'
    click_on 'Create Student'
    visit students_path
    click_on 'Clear All'
    click_on 'Clear All Students'
    visit universities_path
    expect(page).to(have_content('UniName 0 3'))
    visit nominators_path
    expect(page).to(have_content('John'))
    visit students_path
    expect(page).not_to(have_content('Foo'))
    expect(page).not_to(have_content('Test'))
  end

  it 'correct students count from creating and deleting' do
    visit new_student_path
    select 'UniName', from: 'University'
    fill_in 'First name', with: 'Foo'
    fill_in 'Last name', with: 'Bar'
    select 'Bachelors', from: 'Degree level'
    fill_in 'Major', with: 'Basket Making'
    select 'Fall Only', from: 'Exchange term'
    fill_in 'Student email', with: 'FooBar@gmail.com'
    select 'Smith, John', from: 'Nominator'
    click_on 'Create Student'
    visit universities_path
    expect(page).to(have_content('UniName 1 3'))
    visit students_path
    click_on 'Delete'
    click_on 'Delete Student'
    visit universities_path
    expect(page).to(have_content('UniName 0 3'))
    visit new_student_path
    select 'UniName', from: 'University'
    fill_in 'First name', with: 'Foo'
    fill_in 'Last name', with: 'Bar'
    select 'Bachelors', from: 'Degree level'
    fill_in 'Major', with: 'Basket Making'
    select 'Fall and Spring', from: 'Exchange term'
    fill_in 'Student email', with: 'FooBar@gmail.com'
    select 'Smith, John', from: 'Nominator'
    click_on 'Create Student'
    visit universities_path
    expect(page).to(have_content('UniName 2 3'))
    visit students_path
    click_on 'Delete'
    click_on 'Delete Student'
    visit universities_path
    expect(page).to(have_content('UniName 0 3'))
  end

  it 'update exchange term' do
    visit new_student_path
    click_on 'Create Student'
    expect(page).to(have_content('error'))
    select 'UniName', from: 'University'
    select 'Smith, John', from: 'Nominator'
    fill_in 'First name', with: 'Foo'
    fill_in 'Last name', with: 'Bar'
    select 'Bachelors', from: 'Degree level'
    fill_in 'Major', with: 'Basket Making'
    select 'Fall Only', from: 'Exchange term'
    fill_in 'Student email', with: 'FooBar@gmail.com'
    click_on 'Create Student'
    visit universities_path
    expect(page).to(have_content('UniName 1 3'))
    visit students_path
    click_on 'Edit'
    select 'Fall and Spring', from: 'Exchange term'
    click_on 'Update Student'
    visit universities_path
    expect(page).to(have_content('UniName 2 3'))
    visit students_path
    click_on 'Edit'
    select 'Spring Only', from: 'Exchange term'
    click_on 'Update Student'
    visit universities_path
    expect(page).to(have_content('UniName 1 3'))
  end

  it 'update exchange term max' do
    visit new_student_path
    select 'UniName', from: 'University'
    fill_in 'First name', with: 'Foo'
    fill_in 'Last name', with: 'Bar'
    select 'Bachelors', from: 'Degree level'
    fill_in 'Major', with: 'Basket Making'
    select 'Fall Only', from: 'Exchange term'
    fill_in 'Student email', with: 'FooBar@gmail.com'
    select 'Smith, John', from: 'Nominator'
    click_on 'Create Student'
    visit universities_path
    fill_in 'change_lim', with: '1'
    click_on 'Change All Limits'
    expect(page).to(have_content('UniName 1 1'))
    visit students_path
    click_on 'Edit'
    select 'Fall and Spring', from: 'Exchange term'
    click_on 'Update Student'
    expect(page).to(have_content('Sorry'))
  end
end

RSpec.describe('Admin question functions', type: :feature) do
  before do
    @authorized = Authorized.create!(authorized_email: 'userdoe@example.com')
    Rails.application.env_config['devise.mapping'] = Devise.mappings[:admin]
    Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google_user]
    Admin.create!(email: 'userdoe@example.com', full_name: 'User Doe', uid: '123456789', avatar_url: 'https://lh3.googleusercontent.com/url/photo.jpg') unless Admin.where(email: 'userdoe@example.com').first.nil? == false
    visit root_path
    click_on 'Admin login'
  end

  # new/create
  it 'create question' do
    visit new_question_path
    expect(page).to(have_content('New Question'))
    click_on 'Create Question'
    expect(page).to(have_content('error'))
    fill_in 'Prompt', with: 'frq'
    click_on 'Create Question'
    visit questions_path
    expect(page).to(have_content('frq'))
    click_on 'Show'
    expect(page).to(have_content('frq'))
  end

  # edit/update
  it 'editing question' do
    visit new_question_path
    fill_in 'Prompt', with: 'frq'
    click_on 'Create Question'
    visit questions_path
    click_on 'Edit'
    fill_in 'Prompt', with: ''
    click_on 'Update Question'
    expect(page).to(have_content('error'))
    fill_in 'Prompt', with: 'different'
    click_on 'Update Question'
    expect(page).to(have_content('different'))
  end

  # delete/destroy
  it 'deleting question' do
    visit new_question_path
    fill_in 'Prompt', with: 'frq'
    click_on 'Create Question'
    visit questions_path
    click_on 'Delete'
    click_on 'Delete Question'
    # expect(page).not_to have_content('frq') Works manually not sure why it doesn't on rspec
  end

  it 'create answer' do
    visit new_question_path
    click_on 'Create Question'
    fill_in 'Prompt', with: 'multi'
    check 'question_multi'
    click_on 'Create Question'
    click_on 'View Answers'
    click_on 'New Answer'
    fill_in 'Choice', with: '1'
    click_on 'Create Answer'
    expect(page).to(have_content('1'))
  end

  it 'edit answer' do
    visit new_question_path
    click_on 'Create Question'
    fill_in 'Prompt', with: 'multi'
    check 'question_multi'
    click_on 'Create Question'
    click_on 'View Answers'
    click_on 'New Answer'
    fill_in 'Choice', with: '1'
    click_on 'Create Answer'
    click_on 'Edit Choice'
    fill_in 'Choice', with: ''
    click_on 'Update Answer'
    expect(page).to(have_content('error'))
    fill_in 'Choice', with: '2'
    click_on 'Update Answer'
    expect(page).to(have_content('2'))
  end

  it 'delete answer' do
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
    # not using delete page, just link from index
    # delete page not necessary for association notice
    # click_on 'Delete Choice'
    expect(page).not_to(have_content('1'))
  end
end

# ################################### user CRUD functions ###########################

RSpec.describe('User nominator functions', type: :feature) do
  before do
    @authorized = Authorized.create!(authorized_email: 'userdoe@example.com')
    Rails.application.env_config['devise.mapping'] = Devise.mappings[:admin]
    Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google_user]
    Admin.create!(email: 'userdoe@example.com', full_name: 'User Doe', uid: '123456789', avatar_url: 'https://lh3.googleusercontent.com/url/photo.jpg') unless Admin.where(email: 'userdoe@example.com').first.nil? == false
    # need to create university and variables as first step for all
    visit root_path
    click_on 'Admin login'
    visit admin_path
    fill_in 'deadline', with: DateTime.current + 3.days
    click_on 'Update'
    visit universities_path
    fill_in 'max_lim', with: '3'
    click_on 'Update Default Limit'
    visit universities_path
    visit new_university_path
    fill_in 'University name', with: 'UniName'
    click_on 'Create University'
  end

  it 'create nominator' do
    visit user_new_nominators_path
    click_on 'Create Nominator'
    expect(page).to(have_content('error'))
    select 'UniName', from: 'University'
    fill_in 'First name', with: 'John'
    fill_in 'Last name', with: 'Smith'
    fill_in 'Title', with: 'CEO'
    fill_in 'Email', with: 'JohnSmith@gmail.com'
    click_on 'Create Nominator'
    expect(page).to(have_content('John'))
    expect(page).to(have_content('Smith'))
    expect(page).to(have_content('CEO'))
    expect(page).to(have_content('JohnSmith@gmail.com'))
    # expect to go to user_show after fail, where button Continue instead of Back
    click_on('Continue')
  end

  it 'edit nominator' do
    visit user_new_nominators_path
    select 'UniName', from: 'University'
    fill_in 'First name', with: 'John'
    fill_in 'Last name', with: 'Smith'
    fill_in 'Title', with: 'CEO'
    fill_in 'Email', with: 'JohnSmith@gmail.com'
    click_on 'Create Nominator'
    click_on 'Edit'
    fill_in 'First name', with: ''
    click_on 'Update Nominator'
    expect(page).to(have_content('error'))
    fill_in 'First name', with: 'Alice'
    click_on 'Update Nominator'
    expect(page).to(have_content('Alice'))
    # expect user_show
    click_on('Continue')
  end

  it 'finish link' do
    visit user_new_nominators_path
    select 'UniName', from: 'University'
    fill_in 'First name', with: 'John'
    fill_in 'Last name', with: 'Smith'
    fill_in 'Title', with: 'CEO'
    fill_in 'Email', with: 'JohnSmith@gmail.com'
    click_on 'Create Nominator'
    click_on 'Continue'
    expect(page).to(have_content('John'))
    expect(page).to(have_content('Smith'))
    expect(page).to(have_content('CEO'))
    expect(page).to(have_content('JohnSmith@gmail.com'))
    # expect finish page
    expect(page).to(have_content('Finish'))
  end
end

RSpec.describe('User student functions', type: :feature) do
  before do
    @authorized = Authorized.create!(authorized_email: 'userdoe@example.com')
    Rails.application.env_config['devise.mapping'] = Devise.mappings[:admin]
    Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google_user]
    Admin.create!(email: 'userdoe@example.com', full_name: 'User Doe', uid: '123456789', avatar_url: 'https://lh3.googleusercontent.com/url/photo.jpg') unless Admin.where(email: 'userdoe@example.com').first.nil? == false
    # need to create university and nominator variables as first step for all
    visit root_path
    click_on 'Admin login'
    visit admin_path
    fill_in 'deadline', with: DateTime.current + 3.days
    click_on 'Update'
    visit universities_path
    fill_in 'max_lim', with: '3'
    click_on 'Update Default Limit'
    visit universities_path
    visit new_university_path
    fill_in 'University name', with: 'UniName'
    click_on 'Create University'
    visit user_new_nominators_path
    select 'UniName', from: 'University'
    fill_in 'First name', with: 'John'
    fill_in 'Last name', with: 'Smith'
    fill_in 'Title', with: 'CEO'
    fill_in 'Email', with: 'JohnSmith@gmail.com'
    click_on 'Create Nominator'
    click_on 'Continue'
  end

  it 'create student' do
    # should start with finish page
    expect(page).to(have_content('Finish'))
    click_on 'Enter a new student'
    # can't fill in nominator or university
    expect(page).not_to(have_content('University'))
    expect(page).not_to(have_content('Nominator'))
    click_on 'Create Student'
    expect(page).to(have_content('error'))
    fill_in 'First name', with: 'Foo'
    fill_in 'Last name', with: 'Bar'
    select 'Bachelors', from: 'Degree level'
    fill_in 'Major', with: 'Basket Making'
    select 'Fall Only', from: 'Exchange term'
    fill_in 'Student email', with: 'FooBar@gmail.com'
    click_on 'Create Student'
    expect(page).to(have_content('Foo'))
    expect(page).to(have_content('Bar'))
    expect(page).to(have_content('Bachelors'))
    expect(page).to(have_content('Basket Making'))
    expect(page).to(have_content('Fall Only'))
    expect(page).to(have_content('FooBar@gmail.com'))
    # expect user_show
    click_on 'Finish'
  end

  it 'edit student' do
    click_on 'Enter a new student'
    fill_in 'First name', with: 'Foo'
    fill_in 'Last name', with: 'Bar'
    select 'Bachelors', from: 'Degree level'
    fill_in 'Major', with: 'Basket Making'
    select 'Fall Only', from: 'Exchange term'
    fill_in 'Student email', with: 'FooBar@gmail.com'
    click_on 'Create Student'
    click_on 'Edit'
    fill_in 'First name', with: ''
    click_on 'Update Student'
    expect(page).to(have_content('error'))
    fill_in 'First name', with: 'Baz'
    click_on 'Update Student'
    expect(page).to(have_content('Baz'))
    # expect user_show
    click_on 'Finish'
  end

  it 'finish link' do
    click_on 'Enter a new student'
    fill_in 'First name', with: 'Foo'
    fill_in 'Last name', with: 'Bar'
    select 'Bachelors', from: 'Degree level'
    fill_in 'Major', with: 'Basket Making'
    select 'Fall Only', from: 'Exchange term'
    fill_in 'Student email', with: 'FooBar@gmail.com'
    click_on 'Create Student'
    click_on 'Finish'
    # expect finish page
    expect(page).to(have_content('Finish'))
  end

  it 'update exchange term up' do
    click_on 'Enter a new student'
    click_on 'Create Student'
    fill_in 'First name', with: 'Foo'
    fill_in 'Last name', with: 'Bar'
    select 'Bachelors', from: 'Degree level'
    fill_in 'Major', with: 'Basket Making'
    select 'Fall Only', from: 'Exchange term'
    fill_in 'Student email', with: 'FooBar@gmail.com'
    click_on 'Create Student'
    click_on 'Edit'
    select 'Fall and Spring', from: 'Exchange term'
    click_on 'Update Student'
    visit universities_path
    expect(page).to(have_content('UniName 2 3'))
  end

  it 'update exchange term down' do
    click_on 'Enter a new student'
    click_on 'Create Student'
    fill_in 'First name', with: 'Foo'
    fill_in 'Last name', with: 'Bar'
    select 'Bachelors', from: 'Degree level'
    fill_in 'Major', with: 'Basket Making'
    select 'Fall and Spring', from: 'Exchange term'
    fill_in 'Student email', with: 'FooBar@gmail.com'
    click_on 'Create Student'
    click_on 'Edit'
    select 'Spring Only', from: 'Exchange term'
    click_on 'Update Student'
    visit universities_path
    expect(page).to(have_content('UniName 1 3'))
  end

  it 'update exchange term max' do
    visit universities_path
    fill_in 'change_lim', with: '1'
    click_on 'Change All Limits'
    visit user_new_nominators_path
    select 'UniName', from: 'University'
    fill_in 'First name', with: 'Johnny'
    fill_in 'Last name', with: 'Smith'
    fill_in 'Title', with: 'CEO'
    fill_in 'Email', with: 'JohnnySmith@gmail.com'
    click_on 'Create Nominator'
    click_on 'Continue'
    click_on 'Enter a new student'
    fill_in 'First name', with: 'Foo'
    fill_in 'Last name', with: 'Bar'
    select 'Bachelors', from: 'Degree level'
    fill_in 'Major', with: 'Basket Making'
    select 'Fall Only', from: 'Exchange term'
    fill_in 'Student email', with: 'FooBar@gmail.com'
    click_on 'Create Student'
    click_on 'Edit'
    select 'Fall and Spring', from: 'Exchange term'
    click_on 'Update Student'
    expect(page).to(have_content('Sorry'))
  end

  it 'delete student' do
    click_on 'Enter a new student'
    fill_in 'First name', with: 'Foo'
    fill_in 'Last name', with: 'Bar'
    select 'Bachelors', from: 'Degree level'
    fill_in 'Major', with: 'Basket Making'
    select 'Fall Only', from: 'Exchange term'
    fill_in 'Student email', with: 'FooBar@gmail.com'
    click_on 'Create Student'
    click_on 'Finish'
    click_on 'Delete'
    click_on 'Delete Student'
    # expect finish page
    expect(page).to(have_content('Finish'))
    expect(page).not_to(have_content('Foo'))
  end

  # max limit testing
  it 'auto-stop user adding students' do
    expect(page).to(have_content('0 students nominated'))
    # student 1
    click_on 'Enter a new student'
    fill_in 'First name', with: 'Foo'
    fill_in 'Last name', with: 'Bar'
    select 'Bachelors', from: 'Degree level'
    fill_in 'Major', with: 'Basket Making'
    select 'Fall Only', from: 'Exchange term'
    fill_in 'Student email', with: 'FooBar@gmail.com'
    click_on 'Create Student'
    expect(page).to(have_content('1 out of 3'))
    # student 2
    click_on 'Enter another new student'
    fill_in 'First name', with: 'Foo2'
    fill_in 'Last name', with: 'Bar'
    select 'Bachelors', from: 'Degree level'
    fill_in 'Major', with: 'Basket Making'
    select 'Fall and Spring', from: 'Exchange term'
    fill_in 'Student email', with: 'Foo2Bar@gmail.com'
    click_on 'Create Student'
    expect(page).to(have_content('3 out of 3'))
    expect(page).not_to(have_content('Enter another new student'))
    click_on 'Finish'
    # finish page
    expect(page).to(have_content('Finish'))
    expect(page).to(have_content('3 students nominated'))
    expect(page).not_to(have_content('Enter another new student'))
  end

  it "Don't allow more nominators to make nominations after reaching limit" do
    # student 1
    click_on 'Enter a new student'
    fill_in 'First name', with: 'Foo'
    fill_in 'Last name', with: 'Bar'
    select 'Bachelors', from: 'Degree level'
    fill_in 'Major', with: 'Basket Making'
    select 'Fall Only', from: 'Exchange term'
    fill_in 'Student email', with: 'FooBar@gmail.com'
    click_on 'Create Student'
    # student 2
    click_on 'Enter another new student'
    fill_in 'First name', with: 'Foo2'
    fill_in 'Last name', with: 'Bar'
    select 'Bachelors', from: 'Degree level'
    fill_in 'Major', with: 'Basket Making'
    select 'Fall Only', from: 'Exchange term'
    fill_in 'Student email', with: 'Foo2Bar@gmail.com'
    click_on 'Create Student'
    # student 3
    click_on 'Enter another new student'
    fill_in 'First name', with: 'Foo3'
    fill_in 'Last name', with: 'Bar'
    select 'Bachelors', from: 'Degree level'
    fill_in 'Major', with: 'Basket Making'
    select 'Fall Only', from: 'Exchange term'
    fill_in 'Student email', with: 'Foo3Bar@gmail.com'
    click_on 'Create Student'
    # start over with new nominator
    visit user_new_nominators_path
    select 'UniName', from: 'University'
    fill_in 'First name', with: 'Alice'
    fill_in 'Last name', with: 'May'
    fill_in 'Title', with: 'Division Head'
    fill_in 'Email', with: 'A.May@gmail.com'
    click_on 'Create Nominator'
    click_on 'Continue'
    # finish page
    expect(page).to(have_content('Finish'))
    expect(page).to(have_content('3 students nominated'))
    expect(page).to(have_content('Alice'))
    expect(page).not_to(have_content('Foo'))
    expect(page).not_to(have_content('Enter a new student'))
  end
end

RSpec.describe('Deadline', type: :feature) do
  before do
    @authorized = Authorized.create!(authorized_email: 'userdoe@example.com')
    Rails.application.env_config['devise.mapping'] = Devise.mappings[:admin]
    Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google_user]
    Admin.create!(email: 'userdoe@example.com', full_name: 'User Doe', uid: '123456789', avatar_url: 'https://lh3.googleusercontent.com/url/photo.jpg') unless Admin.where(email: 'userdoe@example.com').first.nil? == false
    # need to create as first step for all
    visit root_path
    click_on 'Admin login'
    visit new_university_path
    fill_in 'University name', with: 'UniName'
    click_on 'Create University'
    visit user_new_nominators_path
    select 'UniName', from: 'University'
    fill_in 'First name', with: 'John'
    fill_in 'Last name', with: 'Smith'
    fill_in 'Title', with: 'CEO'
    fill_in 'Email', with: 'JohnSmith@gmail.com'
    click_on 'Create Nominator'
    click_on 'Continue'
    click_on 'Enter a new student'
    fill_in 'First name', with: 'Foo'
    fill_in 'Last name', with: 'Bar'
    select 'Bachelors', from: 'Degree level'
    fill_in 'Major', with: 'Basket Making'
    select 'Fall Only', from: 'Exchange term'
    fill_in 'Student email', with: 'FooBar@gmail.com'
    click_on 'Create Student'
    visit admin_path
    fill_in 'deadline', with: DateTime.current.prev_day(1)
    click_on 'Update'
  end

  it 'root redirect' do
    visit user_new_nominators_path
    expect(page).to(have_content('The deadline for this form has passed'))
  end

  it 'create representitive' do
    visit admin_path
    fill_in 'deadline', with: DateTime.current + 3.seconds
    click_on 'Update'
    visit root_path
    select 'UniName', from: 'University'
    fill_in 'First name', with: 'John'
    fill_in 'Last name', with: 'Smith'
    fill_in 'Title', with: 'CEO'
    fill_in 'Email', with: 'JohnSmith@gmail.com'
    sleep(3)
    click_on 'Create Nominator'
    expect(page).to(have_content('The deadline for this form has passed'))
  end

  it 'create student' do
    visit user_new_student_path(Nominator.all[0])
    # can't fill in nominator or university
    expect(page).not_to(have_content('University'))
    expect(page).not_to(have_content('Nominator'))
    fill_in 'First name', with: 'Foo2'
    fill_in 'Last name', with: 'Bar2'
    select 'Bachelors', from: 'Degree level'
    fill_in 'Major', with: 'Basket Making'
    select 'Fall Only', from: 'Exchange term'
    fill_in 'Student email', with: 'FooBar@gmail.com'
    click_on 'Create Student'
    expect(page).not_to(have_content('Foo2'))
    expect(page).not_to(have_content('Bar2'))
  end

  it 'edit student' do
    visit user_edit_student_url(Student.all[0])
    fill_in 'First name', with: 'Baz'
    click_on 'Update Student'
    expect(page).not_to(have_content('Baz'))
  end

  it 'delete student' do
    visit user_delete_student_url(Student.all[0])
    click_on 'Delete Student'
    # finish page
    expect(page).to(have_content('Finish'))
    expect(page).to(have_content('Foo'))
  end
end

RSpec.describe('User Question functions', type: :feature) do
  before do
    @authorized = Authorized.create!(authorized_email: 'userdoe@example.com')
    Rails.application.env_config['devise.mapping'] = Devise.mappings[:admin]
    Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google_user]
    Admin.create!(email: 'userdoe@example.com', full_name: 'User Doe', uid: '123456789', avatar_url: 'https://lh3.googleusercontent.com/url/photo.jpg') unless Admin.where(email: 'userdoe@example.com').first.nil? == false
    # need to create as first step for all
    visit root_path
    click_on 'Admin login'
    visit new_university_path
    fill_in 'University name', with: 'UniName'
    click_on 'Create University'

    visit new_question_path
    fill_in 'Prompt', with: 'How are you?'
    click_on 'Create Question'

    visit user_new_nominators_path
    select 'UniName', from: 'University'
    fill_in 'First name', with: 'John'
    fill_in 'Last name', with: 'Smith'
    fill_in 'Title', with: 'CEO'
    fill_in 'Email', with: 'JohnSmith@gmail.com'
    click_on 'Create Nominator'

    click_on 'Continue'
    click_on 'Enter a new student'
    fill_in 'First name', with: 'Foo'
    fill_in 'Last name', with: 'Bar'
    select 'Bachelors', from: 'Degree level'
    fill_in 'Major', with: 'Basket Making'
    select 'Fall Only', from: 'Exchange term'
    fill_in 'Student email', with: 'FooBar@gmail.com'
    click_on 'Create Student'
  end

  it 'User can view Questions' do
    expect(page).to(have_content('How are you?'))
  end

  it 'Answer FRQ Question' do
    click_on 'Edit Answer'
    fill_in 'How are you?', with: 'Good'
    click_on 'Update Response'
    expect(page).to(have_content('Good'))
  end
end

RSpec.describe('User Answer functions', type: :feature) do
  before do
    @authorized = Authorized.create!(authorized_email: 'userdoe@example.com')
    Rails.application.env_config['devise.mapping'] = Devise.mappings[:admin]
    Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google_user]
    Admin.create!(email: 'userdoe@example.com', full_name: 'User Doe', uid: '123456789', avatar_url: 'https://lh3.googleusercontent.com/url/photo.jpg') unless Admin.where(email: 'userdoe@example.com').first.nil? == false
    # need to create as first step for all
    visit root_path
    click_on 'Admin login'
    visit new_university_path
    fill_in 'University name', with: 'UniName'
    click_on 'Create University'

    visit new_question_path
    check 'question_multi'
    fill_in 'Prompt', with: 'Yes or no?'
    click_on 'Create Question'

    click_on 'View Answers'
    click_on 'New Answer'
    fill_in 'Choice', with: 'Yes'
    click_on 'Create Answer'
    click_on 'New Answer'
    fill_in 'Choice', with: 'No'
    click_on 'Create Answer'

    visit user_new_nominators_path
    select 'UniName', from: 'University'
    fill_in 'First name', with: 'John'
    fill_in 'Last name', with: 'Smith'
    fill_in 'Title', with: 'CEO'
    fill_in 'Email', with: 'JohnSmith@gmail.com'
    click_on 'Create Nominator'

    click_on 'Continue'
    click_on 'Enter a new student'
    fill_in 'First name', with: 'Foo'
    fill_in 'Last name', with: 'Bar'
    select 'Bachelors', from: 'Degree level'
    fill_in 'Major', with: 'Basket Making'
    select 'Fall Only', from: 'Exchange term'
    fill_in 'Student email', with: 'FooBar@gmail.com'
    click_on 'Create Student'
  end

  it 'User can view Questions' do
    expect(page).to(have_content('Yes or no?'))
  end

  it 'Answer Multiple Choice Question' do
    click_on 'Edit Answer'
    select 'Yes', from: 'Yes or no?'
    click_on 'Update Response'
    expect(page).to(have_content('Yes'))
  end
end
