require 'rails_helper'

RSpec.describe Subscriber, type: :model do
  let(:subscriber) { create(:subscriber) }

  context 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
  end

  it 'is invalid without email' do
    subscriber.email = nil
    expect(subscriber).not_to be_valid
  end

  it 'should have a unique email' do
    email = Faker::Internet.email
    create(:subscriber, email: email)
    subscriber_2 = build(:subscriber, email: email)
    expect { subscriber_2.save }.not_to change { Subscriber.count }
  end
end
