require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do
  describe 'GET index' do
    before do
      get :index
    end

    it 'should be success' do
      expect(response).to be_success
    end

    it 'renders the index template' do
      expect(response).to render_template('index')
    end
  end

  describe 'GET show' do
    let(:category) { create(:category) }

    before do
      get :show, params: { id: category.slug }
    end

    it 'should be success' do
      expect(response).to be_success
    end

    it 'renders the show template' do
      expect(response).to render_template('show')
    end

    it 'should be have a category' do
      expect(assigns(:category)).not_to be_nil
    end
  end
end
