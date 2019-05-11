require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_one(:reward).dependent(:destroy) }

  it { should accept_nested_attributes_for :links }
  it { should accept_nested_attributes_for :reward }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it 'has many attached file' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  it 'should be able to vote a question only once' do
    question = create(:question)
    user = create(:user)

    expect { question.upvote(user) }.to change { question.upvotes.count }.by(1)

    expect { question.downvote(user) }.to change { question.downvotes.count }.by(1)
      .and change { question.upvotes.count }.by(-1)
  end

  it 'should be able to cancel previous vote' do
    question = create(:question)
    user = create(:user)

    question.upvote(user)
    expect { question.upvote(user) }.to change { question.upvotes.count }.by(-1)
  end

  it 'should be able to comment a question' do
    question = create(:question)
    comments_attrs = attributes_for(:comment)
    user = create(:user)

    expect { question.comment(user, { body: comments_attrs[:body] }) }.to change { question.comments.count }.by(1)
  end
end
