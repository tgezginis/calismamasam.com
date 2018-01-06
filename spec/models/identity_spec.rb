require 'rails_helper'

RSpec.describe Identity, type: :model do
  context 'validations' do
    it { should validate_presence_of(:uid) }
  end

  context 'associations' do
    it { should belong_to(:user) }
  end
end
