require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should have_many(:links).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should belong_to(:question).required }

  it { should accept_nested_attributes_for :links }

  it { should validate_presence_of :body }

  it 'should mark answer as best and have only one best answer at a time' do
    question = create(:question_with_answers)

    last_answer = question.answers.last
    last_answer.mark_as_best!

    first_answer = question.answers.first

    expect { first_answer.mark_as_best! }.to change { first_answer.best }.from(false).to(true)
      .and change { last_answer.reload.best }.from(true).to(false)
  end

  it 'should reward user for best answer' do
    question = create(:question_with_answers_and_reward)

    last_answer = question.answers.last

    expect { last_answer.mark_as_best! }.to change { last_answer.author.rewards.count }.by(1)
  end

  it 'has many attached file' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  it 'should be able to vote an answer only once' do
    answer = create(:answer)
    user = create(:user)

    expect { answer.upvote(user) }.to change { answer.upvotes.count }.by(1)

    expect { answer.downvote(user) }.to change { answer.downvotes.count }.by(1)
                                              .and change { answer.upvotes.count }.by(-1)
  end

  it 'should be able to cancel previous vote' do
    answer = create(:answer)
    user = create(:user)

    answer.upvote(user)
    expect { answer.upvote(user) }.to change { answer.upvotes.count }.by(-1)
  end
end
