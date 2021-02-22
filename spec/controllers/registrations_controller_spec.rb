require 'rails_helper'

RSpec.describe RegistrationsController, type: :controller do

  describe 'POST #create' do
    context 'when super-admin passes valid data' do
      it 'creates the admin' do

        post :create, params: { user: {email: 'admin@test.com', password: 'password'}}, format: :json

        expect(response).to have_http_status(:ok)
      end
    end
  end
end