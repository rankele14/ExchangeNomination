require 'rails_helper'

################################### admin CUD functions ###########################

RSpec.describe 'Creating a university', type: :feature do
  scenario 'valid inputs' do
    visit new_university_path
	click_on 'Create University'
	expect(page).to have_content('error')
    fill_in 'University name', with: 'AM'
	click_on 'Create University'
    visit universities_path
    expect(page).to have_content('AM')
  end
end

RSpec.describe 'Editing a university', type: :feature do
  scenario 'valid inputs' do
    visit new_university_path
    fill_in 'University name', with: 'AM'
	click_on 'Create University'
    visit universities_path
    click_on 'Edit'
	fill_in 'University name', with: ''
	click_on 'Update University'
	expect(page).to have_content('error')
	fill_in 'University name', with: 'UT'
	click_on 'Update University'
	visit universities_path
	expect(page).to have_content('UT')
  end
end

RSpec.describe 'Deleting a university', type: :feature do
  scenario 'valid inputs' do
    visit new_university_path
    fill_in 'University name', with: 'AM'
	click_on 'Create University'
    visit universities_path
	click_on 'Delete'
    expect(page).not_to have_content('AM')
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
	fill_in 'Rep email', with: 'JohnSmith@gmail.com'
	click_on 'Create Representative'
    visit representatives_path
    expect(page).to have_content('John')
	expect(page).to have_content('Smith')
	expect(page).to have_content('CEO')
	expect(page).to have_content('JohnSmith@gmail.com')
  end
end

RSpec.describe 'Editing a representative', type: :feature do
  scenario 'valid inputs' do
    visit new_university_path
    fill_in 'University name', with: 'AM'
	click_on 'Create University'
    visit universities_path
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
end

RSpec.describe 'Deleting a representative', type: :feature do
  scenario 'valid inputs' do
    visit new_university_path
    fill_in 'University name', with: 'AM'
	click_on 'Create University'
    visit universities_path
	visit new_representative_path
	select 'AM', :from => 'University'
	fill_in 'First name', with: 'John'
	fill_in 'Last name', with: 'Smith'
	fill_in 'Title', with: 'CEO'
	fill_in 'Rep email', with: 'JohnSmith@gmail.com'
	click_on 'Create Representative'
    visit representatives_path
	click_on 'Delete'
    expect(page).not_to have_content('John')
  end
end

RSpec.describe 'Creating a student', type: :feature do
  scenario 'valid inputs' do
    visit new_university_path
    fill_in 'University name', with: 'AM'
	click_on 'Create University'
    visit universities_path
    expect(page).to have_content('AM')
  visit new_representative_path
    select 'AM', :from => 'University'
    fill_in 'First name', with: 'John'
    fill_in 'Last name', with: 'Smith'
    fill_in 'Title', with: 'CEO'
    fill_in 'Rep email', with: 'JohnSmith@gmail.com'
  click_on 'Create Representative'
    visit representatives_path
    expect(page).to have_content('JohnSmith@gmail.com')
  visit new_student_path
    select 'AM', :from => 'University'
    fill_in 'First name', with: 'Foo'
    fill_in 'Last name', with: 'Bar'
    fill_in 'Degree level', with: 'PHD'
    fill_in 'Major', with: 'Basket Making'
    select 'Fall Only', :from => 'Exchange term'
    fill_in 'Student email', with: 'FooBar@gmail.com'
    select 'Smith, John', :from => 'Representative'
  click_on 'Create Student'
    visit students_path
    expect(page).to have_content('Foo')
    expect(page).to have_content('Bar')
    expect(page).to have_content('AM')
    expect(page).to have_content('John Smith')
    expect(page).to have_content('PHD')
    expect(page).to have_content('Basket Making')
    expect(page).to have_content('Fall Only')
    expect(page).to have_content('FooBar@gmail.com')
  end
end

RSpec.describe 'Editing a student', type: :feature do
  scenario 'valid inputs' do
    visit new_university_path
    fill_in 'University name', with: 'AM'
	click_on 'Create University'
    visit universities_path
  visit new_representative_path
    select 'AM', :from => 'University'
    fill_in 'First name', with: 'John'
    fill_in 'Last name', with: 'Smith'
    fill_in 'Title', with: 'CEO'
    fill_in 'Rep email', with: 'JohnSmith@gmail.com'
  click_on 'Create Representative'
    visit representatives_path
	visit new_student_path
    select 'AM', :from => 'University'
    fill_in 'First name', with: 'Foo'
    fill_in 'Last name', with: 'Bar'
    fill_in 'Degree level', with: 'PHD'
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
end

RSpec.describe 'Deleting a student', type: :feature do
  scenario 'valid inputs' do
    visit new_university_path
    fill_in 'University name', with: 'AM'
	click_on 'Create University'
    visit universities_path
  visit new_representative_path
    select 'AM', :from => 'University'
    fill_in 'First name', with: 'John'
    fill_in 'Last name', with: 'Smith'
    fill_in 'Title', with: 'CEO'
    fill_in 'Rep email', with: 'JohnSmith@gmail.com'
  click_on 'Create Representative'
    visit representatives_path
	visit new_student_path
  select 'AM', :from => 'University'
    fill_in 'First name', with: 'Foo'
    fill_in 'Last name', with: 'Bar'
    fill_in 'Degree level', with: 'PHD'
    fill_in 'Major', with: 'Basket Making'
    select 'Fall Only', :from => 'Exchange term'
    fill_in 'Student email', with: 'FooBar@gmail.com'
    select 'Smith, John', :from => 'Representative'
	click_on 'Create Student'
    visit students_path
	click_on 'Delete'
    expect(page).not_to have_content('Foo')
  end
end

################################### user CRUD functions ###########################

RSpec.describe 'Creating a representative', type: :feature do
  scenario 'valid inputs' do
    visit new_university_path
    fill_in 'University name', with: 'AM'
	click_on 'Create University'
    visit universities_path
	visit user_new_representative_path
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
  click_on 'Continue'
    expect(page).to have_content('John')
    expect(page).to have_content('Smith')
    expect(page).to have_content('CEO')
    expect(page).to have_content('JohnSmith@gmail.com')
  end
end

RSpec.describe 'Editing a representative', type: :feature do
  scenario 'valid inputs' do
    visit new_university_path
    fill_in 'University name', with: 'AM'
	click_on 'Create University'
    visit universities_path
	visit user_new_representative_path
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
  click_on 'Edit'
    fill_in 'First name', with: ''
    click_on 'Update Representative'
    expect(page).to have_content('error')
    fill_in 'First name', with: 'Alice'
  click_on 'Update Representative'
	  expect(page).to have_content('Alice')
  end
end

RSpec.describe 'Creating a student', type: :feature do
  scenario 'valid inputs' do
    visit new_university_path
    fill_in 'University name', with: 'AM'
	click_on 'Create University'
    visit universities_path
	visit user_new_representative_path
    click_on 'Create Representative'
    expect(page).to have_content('error')
    select 'AM', :from => 'University'
    fill_in 'First name', with: 'John'
    fill_in 'Last name', with: 'Smith'
    fill_in 'Title', with: 'CEO'
    fill_in 'Rep email', with: 'JohnSmith@gmail.com'
    click_on 'Create Representative'
  click_on 'Continue'
  click_on 'Enter a new student'
    expect(page).not_to have_content('University')
    expect(page).not_to have_content('Representative')
    fill_in 'First name', with: 'Foo'
    fill_in 'Last name', with: 'Bar'
    fill_in 'Degree level', with: 'PHD'
    fill_in 'Major', with: 'Basket Making'
    select 'Fall Only', :from => 'Exchange term'
    fill_in 'Student email', with: 'FooBar@gmail.com'
  click_on 'Create Student'
    expect(page).to have_content('Foo')
    expect(page).to have_content('Bar')
    expect(page).to have_content('PHD')
    expect(page).to have_content('Basket Making')
    expect(page).to have_content('Fall Only')
    expect(page).to have_content('FooBar@gmail.com')
  end
end

RSpec.describe 'Editing a student', type: :feature do
  scenario 'valid inputs' do
    visit new_university_path
    fill_in 'University name', with: 'AM'
	click_on 'Create University'
    visit universities_path
	visit user_new_representative_path
    click_on 'Create Representative'
    expect(page).to have_content('error')
    select 'AM', :from => 'University'
    fill_in 'First name', with: 'John'
    fill_in 'Last name', with: 'Smith'
    fill_in 'Title', with: 'CEO'
    fill_in 'Rep email', with: 'JohnSmith@gmail.com'
    click_on 'Create Representative'
  click_on 'Continue'
  click_on 'Enter a new student'
    expect(page).not_to have_content('University')
    expect(page).not_to have_content('Representative')
    fill_in 'First name', with: 'Foo'
    fill_in 'Last name', with: 'Bar'
    fill_in 'Degree level', with: 'PHD'
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
  end
end

RSpec.describe 'Deleting a student', type: :feature do
  scenario 'valid inputs' do
    visit new_university_path
    fill_in 'University name', with: 'AM'
	click_on 'Create University'
    visit universities_path
	visit user_new_representative_path
    click_on 'Create Representative'
    expect(page).to have_content('error')
    select 'AM', :from => 'University'
    fill_in 'First name', with: 'John'
    fill_in 'Last name', with: 'Smith'
    fill_in 'Title', with: 'CEO'
    fill_in 'Rep email', with: 'JohnSmith@gmail.com'
    click_on 'Create Representative'
  click_on 'Continue'
  click_on 'Enter a new student'
    expect(page).not_to have_content('University')
    expect(page).not_to have_content('Representative')
    fill_in 'First name', with: 'Foo'
    fill_in 'Last name', with: 'Bar'
    fill_in 'Degree level', with: 'PHD'
    fill_in 'Major', with: 'Basket Making'
    select 'Fall Only', :from => 'Exchange term'
    fill_in 'Student email', with: 'FooBar@gmail.com'
  click_on 'Create Student'
  click_on 'Finish'
	click_on 'Delete'
    expect(page).not_to have_content('Foo')
  end
end

################################### max limit variable ###########################

RSpec.describe 'Admin max limit nominees', type: :feature do
  scenario 'valid inputs' do 
    visit admin_path
	  expect(page).to have_content('3')
    fill_in 'max_lim', with: '5'
  click_on 'Update Limit'
  visit admin_path
    expect(page).not_to have_content('3')
	  expect(page).to have_content('5')
  end
end

#Rspec.describe 'Auto-stop user adding students'
#Rspec.describe 'Auto-stop

#admin add new does not interact with limit


#test destroy associations
#valid email