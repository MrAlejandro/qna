require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  it 'should return true if user is the author of resource' do
    question = create(:question)
    expect(question.author.author?(question)).to be true
  end

  it 'should return false if user is not the author of resource' do
    answer = create(:answer)
    other_user = create(:user)
    expect(other_user.author?(answer)).to be false
  end
end
