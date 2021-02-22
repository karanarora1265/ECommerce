require 'rails_helper'
RSpec.describe RegistrationsController do

  describe 'POST #create' do
    before :each do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      @super_admin = create(:user, email: 'sa@test.com', type: 'SuperAdmin')
      @admin = create(:user, email: 'admin@test.com', type: 'Admin')
      @contributor = create(:user, email: 'contributor@test.com', type: 'Contributor')
    end

    context 'when super-admin passes valid data' do
      it 'creates an admin' do
        request.headers['Authorization'] = ActionController::HttpAuthentication::Token.encode_credentials(@super_admin.generate_jwt)
        post :create, params: {user: {email: 'admin2@test.com', password: 'password'}}, format: :json
        expect(response).to have_http_status(:created)
        json_body = JSON.parse(response.body)
        expect(json_body["email"]).to eq('admin2@test.com')
        expect(Admin.last.email).to eq('admin2@test.com')
      end
    end
    context 'when admin passes valid data' do
      it 'creates an contributor' do
        request.headers['Authorization'] = ActionController::HttpAuthentication::Token.encode_credentials(@admin.generate_jwt)
        post :create, params: {user: {email: 'contributor2@test.com', password: 'password'}}, format: :json
        expect(response).to have_http_status(:created)
        json_body = JSON.parse(response.body)
        expect(json_body["email"]).to eq('contributor2@test.com')
        expect(Contributor.last.email).to eq('contributor2@test.com')
      end
    end
    context 'when super-admin passes invalid data' do
      it 'returns 422 if email invalid' do
        request.headers['Authorization'] = ActionController::HttpAuthentication::Token.encode_credentials(@super_admin.generate_jwt)
        post :create, params: {user: {email: 'admintest.com', password: 'password'}}, format: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end
      it 'returns 422 if email duplicate' do
        request.headers['Authorization'] = ActionController::HttpAuthentication::Token.encode_credentials(@super_admin.generate_jwt)
        post :create, params: {user: {email: 'admin@test.com', password: 'password'}}, format: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end
      it 'returns 422 if password blank' do
        request.headers['Authorization'] = ActionController::HttpAuthentication::Token.encode_credentials(@super_admin.generate_jwt)
        post :create, params: {user: {email: 'admin2@test.com', password: ''}}, format: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end
      it 'returns 401 if invalid authroization' do
        request.headers['Authorization'] = ActionController::HttpAuthentication::Token.encode_credentials("fake")
        post :create, params: {user: {email: 'admin@test.com', password: ''}}, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
    context 'when admin passes invalid data' do
      it 'returns 422 if email invalid' do
        request.headers['Authorization'] = ActionController::HttpAuthentication::Token.encode_credentials(@admin.generate_jwt)
        post :create, params: {user: {email: 'contributortest.com', password: 'password'}}, format: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end
      it 'returns 422 if email duplicate' do
        request.headers['Authorization'] = ActionController::HttpAuthentication::Token.encode_credentials(@admin.generate_jwt)
        post :create, params: {user: {email: 'contributor@test.com', password: 'password'}}, format: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end
      it 'returns 422 if password blank' do
        request.headers['Authorization'] = ActionController::HttpAuthentication::Token.encode_credentials(@admin.generate_jwt)
        post :create, params: {user: {email: 'contributor@test.com', password: ''}}, format: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end
      it 'returns 401 if invalid authroization' do
        request.headers['Authorization'] = ActionController::HttpAuthentication::Token.encode_credentials("fake")
        post :create, params: {user: {email: 'contributor@test.com', password: ''}}, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end

  end
end