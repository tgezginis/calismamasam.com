require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  describe 'GET show' do
    let(:post) { create(:post) }

    context 'when the post is active' do
      before do
        create(:post_image, post: post)
        post.is_active = true
        post.save!
        get :show, params: { id: post.slug }
      end

      it 'should be success' do
        expect(response).to be_success
      end

      it 'renders the show template' do
        expect(response).to render_template('show')
      end

      it 'should be have a post' do
        expect(assigns(:post)).not_to be_nil
      end
    end

    context 'when the post is inactive' do
      before do
        get :show, params: { id: post.slug }
      end

      it 'should be redirect' do
        expect(response).not_to be_success
      end

      it 'redirects to home' do
        expect(response).to redirect_to(root_url)
      end
    end
  end

  describe 'GET about' do
    before do
      get :about
    end

    it 'should be success' do
      expect(response).to be_success
    end

    it 'renders the about template' do
      expect(response).to render_template('about')
    end
  end

  describe 'GET feed' do
    before do
      get :feed, format: 'rss'
    end

    it 'should be success' do
      expect(response).to be_success
    end

    it 'renders the feed template' do
      expect(response).to render_template('feed')
    end

    it 'should be rss/xml type' do
      expect(response.content_type).to eq('application/rss+xml')
    end
  end
end
