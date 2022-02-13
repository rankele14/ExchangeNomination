require 'rails_helper'

RSpec.describe 'Creating a university', type: :feature do
  scenario 'valid inputs' do
    visit new_university_path
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
	page.driver.browser.switch_to.alert.accept
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
	page.driver.browser.switch_to.alert.accept
    expect(page).not_to have_content('John')
  end
end

RSpec.describe 'Creating a student', type: :feature do
  scenario 'valid inputs' do
    visit new_university_path
    fill_in 'University name', with: 'AM'
	click_on 'Create University'
    visit universities_path
	visit new_student_path
	select 'AM', :from => 'University'
	fill_in 'First name', with: 'Foo'
	fill_in 'Last name', with: 'Bar'
	fill_in 'Degree level', with: 'PHD'
	fill_in 'Major', with: 'Basket Making'
	select 'Fall Only', :from => 'Exchange term'
	fill_in 'Student email', with: 'FooBar@gmail.com'
	click_on 'Create Student'
    visit students_path
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
	visit new_student_path
	select 'AM', :from => 'University'
	fill_in 'First name', with: 'Foo'
	fill_in 'Last name', with: 'Bar'
	fill_in 'Degree level', with: 'PHD'
	fill_in 'Major', with: 'Basket Making'
	select 'Fall Only', :from => 'Exchange term'
	fill_in 'Student email', with: 'FooBar@gmail.com'
	click_on 'Create Student'
    visit students_path
    click_on 'Edit'
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
	visit new_student_path
	select 'AM', :from => 'University'
	fill_in 'First name', with: 'Foo'
	fill_in 'Last name', with: 'Bar'
	fill_in 'Degree level', with: 'PHD'
	fill_in 'Major', with: 'Basket Making'
	select 'Fall Only', :from => 'Exchange term'
	fill_in 'Student email', with: 'FooBar@gmail.com'
	click_on 'Create Student'
    visit students_path
    click_on 'Delete'
	page.driver.browser.switch_to.alert.accept
    expect(page).not_to have_content('Foo')
  end
end
