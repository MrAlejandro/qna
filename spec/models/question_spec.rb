require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it 'has many attached file' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  it 'removes attached file' do
    question = create(:question)
    question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')

    expect { question.delete_file(question.files.first.id) }.to change { question.files.count }.by(-1)
  end
end
