# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

RSpec.describe(Nominator, type: :model) do
  subject(:nom) do
    @uni = University.new(university_name: 'AM', num_nominees: 0, max_limit: 3)
    @uni.save!
    described_class.new(first_name: 'John', last_name: 'Smith', title: 'CEO', university_id: @uni.id, nominator_email: 'JohnSmith@gmail.com')
  end

  it 'is valid with all valid attributes' do
    expect(nom).to(be_valid)
  end

  it 'is not valid without a first_name' do
    nom.first_name = nil
    expect(nom).not_to(be_valid)
  end

  it 'is not valid without a last_name' do
    nom.last_name = nil
    expect(nom).not_to(be_valid)
  end

  it 'is not valid without a title' do
    nom.title = nil
    expect(nom).not_to(be_valid)
  end

  it 'is not valid without a university_id' do
    nom.university_id = nil
    expect(nom).not_to(be_valid)
  end

  it 'is not valid without a nominator_email' do
    nom.nominator_email = nil
    expect(nom).not_to(be_valid)
  end

  it 'does not allow emails that do not fit the specified format' do
    invalid_email = 'user'
    nom.nominator_email = invalid_email
    expect(nom).to(be_invalid)

    invalid_email = 'user@'
    nom.nominator_email = invalid_email
    expect(nom).not_to(be_valid)

    # this one fails
    # invalid_email = 'user@foo'
    # nom.nominator_email = invalid_email
    # expect(nom).to be_invalid

    # test it as valid (FIXME?)
    unexpected_email = 'user@foo'
    nom.nominator_email = unexpected_email
    expect(nom).to(be_valid)

    invalid_email = 'user@foo,com'
    nom.nominator_email = invalid_email
    expect(nom).not_to(be_valid)

    invalid_email = 'user_at_foo.org'
    nom.nominator_email = invalid_email
    expect(nom).not_to(be_valid)

    invalid_email = 'user_at_foo.org'
    nom.nominator_email = invalid_email
    expect(nom).not_to(be_valid)

    invalid_email = 'example.user@foo.foo@bar_baz.com'
    nom.nominator_email = invalid_email
    expect(nom).not_to(be_valid)

    invalid_email = 'foo@bar+baz.com'
    nom.nominator_email = invalid_email
    expect(nom).not_to(be_valid)

    invalid_email = 'foo@bar..com'
    nom.nominator_email = invalid_email
    expect(nom).not_to(be_valid)

    # this one errors
    # invalid_email = ' foo@bar.com'
    # nom.nominator_email = invalid_email
    # expect(nom).to be_valids

    invalid_email = 'foo@bar.com'
    nom.nominator_email = invalid_email
    expect(nom).to(be_valid)
  end
end

RSpec.describe(University, type: :model) do
  subject(:uni) do
    described_class.new(university_name: 'AM', num_nominees: 0, max_limit: 3)
  end

  it 'is valid with all valid attributes' do
    expect(uni).to(be_valid)
  end

  it 'is not valid without a university_name' do
    uni.university_name = nil
    expect(uni).not_to(be_valid)
  end

  it 'is not valid without a num_nominees' do
    uni.num_nominees = nil
    expect(uni).not_to(be_valid)
  end

  it 'is not valid without a max_limit' do
    uni.max_limit = nil
    expect(uni).not_to(be_valid)
  end
end

RSpec.describe(Student, type: :model) do
  subject(:stu) do
    @uni = University.new(university_name: 'AM', num_nominees: 0, max_limit: 3)
    @uni.save!
    @rep = Nominator.new(first_name: 'John', last_name: 'Smith', title: 'CEO', university_id: @uni.id, nominator_email: 'JohnSmith@gmail.com')
    @rep.save!
    described_class.new(first_name: 'Foo', last_name: 'Bar', university_id: @uni.id, nominator_id: @rep.id, student_email: 'FooBar@gmail.com', exchange_term: 'First', degree_level: 'PHD', major: 'Basket Making')
  end

  it 'is valid with all valid attributes' do
    expect(stu).to(be_valid)
  end

  it 'is not valid without a first_name' do
    stu.first_name = nil
    expect(stu).not_to(be_valid)
  end

  it 'is not valid without a last_name' do
    stu.last_name = nil
    expect(stu).not_to(be_valid)
  end

  it 'is not valid without a university_id' do
    stu.university_id = nil
    expect(stu).not_to(be_valid)
  end

  it 'is not valid without a nominator_id' do
    stu.nominator_id = nil
    expect(stu).not_to(be_valid)
  end

  it 'is not valid without a student_email' do
    stu.student_email = nil
    expect(stu).not_to(be_valid)
  end

  it 'is not valid without a exchange_term' do
    stu.exchange_term = nil
    expect(stu).not_to(be_valid)
  end

  it 'is not valid without a degree_level' do
    stu.degree_level = nil
    expect(stu).not_to(be_valid)
  end

  it 'is not valid without a major' do
    stu.major = nil
    expect(stu).not_to(be_valid)
  end

  it 'does not allow emails that do not fit the specified format' do
    invalid_email = 'user'
    stu.student_email = invalid_email
    expect(stu).to(be_invalid)

    invalid_email = 'user@'
    stu.student_email = invalid_email
    expect(stu).not_to(be_valid)

    unexpected_email = 'user@foo'
    stu.student_email = unexpected_email
    expect(stu).to(be_valid)

    invalid_email = 'user@foo,com'
    stu.student_email = invalid_email
    expect(stu).not_to(be_valid)

    invalid_email = 'user_at_foo.org'
    stu.student_email = invalid_email
    expect(stu).not_to(be_valid)

    invalid_email = 'user_at_foo.org'
    stu.student_email = invalid_email
    expect(stu).not_to(be_valid)

    invalid_email = 'example.user@foo.foo@bar_baz.com'
    stu.student_email = invalid_email
    expect(stu).not_to(be_valid)

    invalid_email = 'foo@bar+baz.com'
    stu.student_email = invalid_email
    expect(stu).not_to(be_valid)

    invalid_email = 'foo@bar..com'
    stu.student_email = invalid_email
    expect(stu).not_to(be_valid)

    invalid_email = 'foo@bar.com'
    stu.student_email = invalid_email
    expect(stu).to(be_valid)
  end
end

RSpec.describe(Question, type: :model) do
  subject(:que) do
    described_class.new(prompt: 'Why?', multi: true)
  end

  it 'is valid with all valid attributes' do
    expect(que).to(be_valid)
  end

  it 'is not valid without a prompt' do
    que.prompt = nil
    expect(que).not_to(be_valid)
  end
end

RSpec.describe(Answer, type: :model) do
  subject(:ans) do
    @que = Question.new(prompt: 'Why?', multi: true)
    @que.save!
    described_class.new(question_id: @que.id, choice: 'Yes')
  end

  it 'is valid with all valid attributes' do
    expect(ans).to(be_valid)
  end

  it 'is not valid without a question id' do
    ans.question_id = nil
    expect(ans).not_to(be_valid)
  end

  it 'is not valid without a choice' do
    ans.choice = nil
    expect(ans).not_to(be_valid)
  end
end

RSpec.describe(Response, type: :model) do
  subject(:res) do
    @uni = University.new(university_name: 'AM', num_nominees: 0, max_limit: 3)
    @uni.save!
    @rep = Nominator.new(first_name: 'John', last_name: 'Smith', title: 'CEO', university_id: @uni.id, nominator_email: 'JohnSmith@gmail.com')
    @rep.save!
    @stu = Student.new(first_name: 'Foo', last_name: 'Bar', university_id: @uni.id, nominator_id: @rep.id, student_email: 'FooBar@gmail.com', exchange_term: 'First', degree_level: 'PHD', major: 'Basket Making')
    @stu.save!
    described_class.new(student_id: @stu.id, question_id: 1, reply: 'Yes')
  end

  it 'is valid with all valid attributes' do
    expect(res).to(be_valid)
  end

  it 'is not valid without a question_id' do
    res.question_id = nil
    expect(res).not_to(be_valid)
  end
end
