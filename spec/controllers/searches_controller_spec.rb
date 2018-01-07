require 'rails_helper'

RSpec.describe SearchesController, type: :controller do
  describe 'GET show' do
    before do
      get :show, params: { query: 'Test' }
    end

    it 'should be success' do
      expect(response).to be_success
    end

    it 'renders the show template' do
      expect(response).to render_template('show')
    end
  end
end
