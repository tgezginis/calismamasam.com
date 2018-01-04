require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  context 'validations' do
    it { should validate_uniqueness_of(:email).ignoring_case_sensitivity }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:name) }
  end

  context 'associations' do
    it { should have_many(:galleries) }
  end

  context 'scopes' do
    it 'admins' do
      admin = create(:user, role: :admin)
      expect(admin.admin?).to be_truthy
      expect(User.admins).to include admin
    end
  end

  it 'is invalid without email' do
    user.email = nil
    expect(user).not_to be_valid
  end

  it 'is invalid without password' do
    user.password = nil
    expect(user).not_to be_valid
  end

  it 'is invalid when the password different with password confirmation' do
    user.password = Faker::Internet.password(8)
    user.password_confirmation = Faker::Internet.password(8)
    expect(user).not_to be_valid
  end

  it 'should have a unique email' do
    email = Faker::Internet.email
    create(:user, email: email)
    user2 = build(:user, email: email)
    expect { user2.save }.not_to change { User.count }
  end

  it 'should set default role' do
    new_user = create(:user, role: nil)
    expect(new_user.role).to eq 'user'
    expect(new_user.user?).to be_truthy
  end

  it 'should check role' do
    User.roles.each do |user_role|
      new_user = create(:user, role: user_role.first.to_sym)
      expect(new_user.method("#{user_role}?")).to be_truthy
    end
  end

  it 'should like/unlike a gallery' do
    gallery = create(:gallery)
    expect { user.like(Gallery, gallery.id) }.to change { gallery.likes_count }
    expect { user.unlike(Gallery, gallery.id) }.to change { gallery.likes_count }
  end

  it 'should like/unline a post' do
    post = create(:post)
    expect { user.like(Post, post.id) }.to change { post.likes_count }
    expect { user.unlike(Post, post.id) }.to change { post.likes_count }
  end
end
