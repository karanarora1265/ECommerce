require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  let(:super_admin) { SuperAdmin.create(email: 'sa@test.com', password: 'password') }

  describe 'POST #create' do
    context 'when super-admin passes valid data' do
      it 'returns the token' do
        post :create, params: {email: 'sa@test.com', password: 'password'}, format: :json

        expect(response).to have_http_status(:ok)
      end
    end
  end
end