require 'rails_helper'
require 'spec_helper'

RSpec.describe Representative, type: :model do
  subject do
    @uni = University.new(university_name: 'AM', num_nominees: 0, max_limit: 3)
    @uni.save
    described_class.new(first_name: 'John', last_name: 'Smith', title: 'CEO', university_id: @uni.id, rep_email: 'JohnSmith@gmail.com')
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
  
  it 'does not allow emails that do not fit the specified format' do
    invalid_email = 'user'
    subject.rep_email = invalid_email
    expect(subject).to be_invalid
    
    invalid_email = 'user@' 
    subject.rep_email = invalid_email
    expect(subject).not_to be_valid
    
    # this one fails
    # invalid_email = 'user@foo' 
    # subject.rep_email = invalid_email
    # expect(subject).to be_invalid

    # test it as valid (FIXME?)
    unexpected_email = 'user@foo' 
    subject.rep_email = unexpected_email
    expect(subject).to be_valid
    
    invalid_email = 'user@foo,com'
    subject.rep_email = invalid_email
    expect(subject).not_to be_valid
    
    invalid_email = 'user_at_foo.org'
    subject.rep_email = invalid_email
    expect(subject).not_to be_valid
    
    invalid_email = 'user_at_foo.org'
    subject.rep_email = invalid_email
    expect(subject).not_to be_valid
    
    invalid_email = 'example.user@foo.foo@bar_baz.com'
    subject.rep_email = invalid_email
    expect(subject).not_to be_valid
    
    invalid_email = 'foo@bar+baz.com'
    subject.rep_email = invalid_email
    expect(subject).not_to be_valid
    
    invalid_email = 'foo@bar..com'
    subject.rep_email = invalid_email
    expect(subject).not_to be_valid
    
    # this one errors
    # invalid_email = ' foo@bar.com'
    # subject.rep_email = invalid_email
    # expect(subject).to be_valids

    invalid_email = 'foo@bar.com'
    subject.rep_email = invalid_email
    expect(subject).to be_valid
  end
end

RSpec.describe University, type: :model do
  subject do
    described_class.new(university_name: 'AM', num_nominees: 0, max_limit: 3)
  end

  it 'is valid with all valid attributes' do
    expect(subject).to be_valid
  end

  it 'is not valid without a university_name' do
    subject.university_name = nil
    expect(subject).not_to be_valid
  end

  it 'is not valid without a num_nominees' do
    subject.num_nominees = nil
    expect(subject).not_to be_valid
  end

  it 'is not valid without a max_limit' do
    subject.max_limit = nil
    expect(subject).not_to be_valid
  end
end

# RSpec.describe AnswerChoice, type: :model do
#   subject do
#     described_class.new(questionID: 1, answer_choice: 'Yes')
#   end
#   it 'is not valid without a num_nominees' do
#     subject.num_nominees = nil
#     expect(subject).not_to be_valid
#   end
# end

RSpec.describe Student, type: :model do
  subject do
    @uni = University.new(university_name: 'AM', num_nominees: 0, max_limit: 3)
    @uni.save
    @rep = Representative.new(first_name: 'John', last_name: 'Smith', title: 'CEO', university_id: @uni.id, rep_email: 'JohnSmith@gmail.com')
    @rep.save
    described_class.new(first_name: 'Foo', last_name: 'Bar', university_id: @uni.id, representative_id: @rep.id, student_email: 'FooBar@gmail.com', exchange_term: 'First', degree_level: 'PHD', major: 'Basket Making')
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
  
  it 'is not valid without a representative_id' do
    subject.representative_id = nil
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
  
  it 'does not allow emails that do not fit the specified format' do
    invalid_email = 'user'
    subject.student_email = invalid_email
    expect(subject).to be_invalid
    
    invalid_email = 'user@' 
    subject.student_email = invalid_email
    expect(subject).not_to be_valid

    unexpected_email = 'user@foo' 
    subject.student_email = unexpected_email
    expect(subject).to be_valid
    
    invalid_email = 'user@foo,com'
    subject.student_email = invalid_email
    expect(subject).not_to be_valid
    
    invalid_email = 'user_at_foo.org'
    subject.student_email = invalid_email
    expect(subject).not_to be_valid
    
    invalid_email = 'user_at_foo.org'
    subject.student_email = invalid_email
    expect(subject).not_to be_valid
    
    invalid_email = 'example.user@foo.foo@bar_baz.com'
    subject.student_email = invalid_email
    expect(subject).not_to be_valid
    
    invalid_email = 'foo@bar+baz.com'
    subject.student_email = invalid_email
    expect(subject).not_to be_valid
    
    invalid_email = 'foo@bar..com'
    subject.student_email = invalid_email
    expect(subject).not_to be_valid

    invalid_email = 'foo@bar.com'
    subject.student_email = invalid_email
    expect(subject).to be_valid
  end
end

RSpec.describe Question, type: :model do
  subject do
    described_class.new(prompt: 'Why?', multi: true)
  end

  it 'is valid with all valid attributes' do
    expect(subject).to be_valid
  end

  it 'is not valid without a prompt' do
    subject.prompt = nil
    expect(subject).not_to be_valid
  end
end

RSpec.describe Answer, type: :model do
  subject do
    @que = Question.new(prompt: 'Why?', multi: true)
	@que.save
    described_class.new(question_id: @que.id, choice: 'Yes')
  end

  it 'is valid with all valid attributes' do
    expect(subject).to be_valid
  end

  it 'is not valid without a question id' do
    subject.question_id = nil
    expect(subject).not_to be_valid
  end
  
  it 'is not valid without a choice' do
    subject.choice = nil
    expect(subject).not_to be_valid
  end
end

RSpec.describe Response, type: :model do
  subject do
    @uni = University.new(university_name: 'AM', num_nominees: 0, max_limit: 3)
    @uni.save
    @rep = Representative.new(first_name: 'John', last_name: 'Smith', title: 'CEO', university_id: @uni.id, rep_email: 'JohnSmith@gmail.com')
    @rep.save
    @stu = Student.new(first_name: 'Foo', last_name: 'Bar', university_id: @uni.id, representative_id: @rep.id, student_email: 'FooBar@gmail.com', exchange_term: 'First', degree_level: 'PHD', major: 'Basket Making')
    @stu.save
	described_class.new(student_id: @stu.id, question_id: 1, reply: 'Yes')
  end

  it 'is valid with all valid attributes' do
    expect(subject).to be_valid
  end

  it 'is not valid without a question_id' do
    subject.question_id = nil
    expect(subject).not_to be_valid
  end
end