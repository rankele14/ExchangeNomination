require 'rails_helper'

RSpec.describe Representative, type: :model do
  subject do
    described_class.new(first_name: 'John', last_name: 'Smith', title: 'CEO', university_id: 1, rep_email: 'JohnSmith@gmail.com')
  end

  it 'is valid with all valid attributes' do
    expect(subject).to be_valid
  end

  it 'is not valid without a first_name' do
    subject.first_name = nil
    expect(subject).not_to be_valid
  end

  it 'is not valid without a last_name' do
    subject.last_name = nil
    expect(subject).not_to be_valid
  end

  it 'is not valid without a title' do
    subject.title = nil
    expect(subject).not_to be_valid
  end

  it 'is not valid without a university_id' do
    subject.university_id = nil
    expect(subject).not_to be_valid
  end
  
  it 'is not valid without a rep_email' do
    subject.rep_email = nil
    expect(subject).not_to be_valid
  end
end

RSpec.describe University, type: :model do
  subject do
    described_class.new(university_name: 'AM')
  end

  it 'is valid with all valid attributes' do
    expect(subject).to be_valid
  end

  it 'is not valid without a university_name' do
    subject.university_name = nil
    expect(subject).not_to be_valid
  end
end

RSpec.describe Student, type: :model do
  subject do
    described_class.new(first_name: 'Foo', last_name: 'Bar', university_id: 1, student_email: 'FooBar@gmail.com', exchange_term: 'First', degree_level: 'PHD', major: 'Basket Making')
  end

  it 'is valid with all valid attributes' do
    expect(subject).to be_valid
  end

  it 'is not valid without a first_name' do
    subject.first_name = nil
    expect(subject).not_to be_valid
  end
  
  it 'is not valid without a last_name' do
    subject.last_name = nil
    expect(subject).not_to be_valid
  end
  
  it 'is not valid without a university_id' do
    subject.university_id = nil
    expect(subject).not_to be_valid
  end
  
  it 'is not valid without a student_email' do
    subject.student_email= nil
    expect(subject).not_to be_valid
  end
  
  it 'is not valid without a exchange_term' do
    subject.exchange_term = nil
    expect(subject).not_to be_valid
  end
  
  it 'is not valid without a degree_level' do
    subject.degree_level = nil
    expect(subject).not_to be_valid
  end
    
  it 'is not valid without a major' do
    subject.major = nil
    expect(subject).not_to be_valid
  end
end
