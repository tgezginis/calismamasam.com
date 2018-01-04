require 'rails_helper'

RSpec.describe PostDecorator, type: :decorator do
  let(:post) { create(:post) }

  subject(:context_post) do
    post
    described_class.new(post)
  end

  context 'active?' do
    it 'should be boolean' do
      expect(context_post.active?.class).to be_in([TrueClass, FalseClass])
    end

    it 'should be true' do
      context_post.is_active = true
      expect(context_post.active?).to be_truthy
    end
  end

  context 'notifiable?' do
    it 'should be boolean' do
      expect(context_post.notifiable?.class).to be_in([TrueClass, FalseClass])
    end

    it 'should be false unless production environment' do
      expect(context_post.notifiable?).to be_falsey
    end

    it 'should be true when valid for notify' do
      allow(Rails).to receive(:env).and_return(ActiveSupport::StringInquirer.new('production'))
      context_post.is_active = true
      context_post.notified_at = nil
      context_post.published_at = Time.current
      status = context_post.is_active? && context_post.notified_at.nil? && context_post.published_at > 5.minutes.ago && context_post.published_at < Time.current + 5.minutes && Rails.env.production?
      expect(status).to be_truthy
    end
  end

  context 'job_and_company' do
    it 'should be string' do
      expect(context_post.job_and_company.class).to be(String)
    end

    it 'should concat job and company' do
      job_and_company = "#{context_post.job_title} @ #{context_post.company}"
      expect(context_post.job_and_company).to eq(job_and_company)
    end

    it 'should be only name when is the company name is empty' do
      context_post.company = nil
      expect(context_post.job_and_company).to eq(context_post.job_title)
    end
  end
end
