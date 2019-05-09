require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to :user }
  it { should belong_to :votable }
  it { should validate_presence_of :value }
  it { should validate_uniqueness_of(:value).scoped_to([:user_id, :votable_id]) }
  it { should allow_values(Vote::VOTE_CODE_DOWN, Vote::VOTE_CODE_UP).for(:value) }
  it { should_not allow_values('dummy', false, 777).for(:value) }
end
