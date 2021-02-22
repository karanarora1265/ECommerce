require 'rails_helper'
RSpec.describe SessionsController do

  before :each do
    @request.env['devise.mapping'] = Devise.mappings[:user]
    @super_admin = create(:user, email: 'sa@test.com', type: 'SuperAdmin')
    @admin = create(:user, email: 'admin@test.com', type: 'Admin')
    @contributor = create(:user, email: 'contributor@test.com', type: 'Contributor')
  end
  describe 'POST #create' do

    context 'when passes valid data' do
      it 'returns the token for superadmin' do
        post :create, params: {email: 'sa@test.com', password: 'password'}, format: :json
        json_body = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
        expect(json_body["email"]).to eq(@super_admin.email)
        expect(json_body.include? "token").to eq(true)
      end
      it 'returns the token for admin' do
        post :create, params: {email: 'admin@test.com', password: 'password'}, format: :json
        json_body = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
        expect(json_body["email"]).to eq(@admin.email)
        expect(json_body.include? "token").to eq(true)
      end
      it 'returns the token for contributor' do
        post :create, params: {email: 'contributor@test.com', password: 'password'}, format: :json
        json_body = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
        expect(json_body["email"]).to eq(@contributor.email)
        expect(json_body.include? "token").to eq(true)
      end
    end
    context 'when passes invalid email' do
      it 'returns unprocessable_entity error for superadmin' do
        post :create, params: {email: 'unknown@test.com', password: 'password'}, format: :json
        json_body = JSON.parse(response.body)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_body.include? "token").to eq(false)
        expect(json_body.include? "email").to eq(false)
      end
    end
    context 'when passes invalid password' do
      it 'returns unprocessable_entity error' do
        post :create, params: {email: 'sa@test.com', password: 'passwrd'}, format: :json
        json_body = JSON.parse(response.body)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_body.include? "token").to eq(false)
        expect(json_body.include? "email").to eq(false)
      end
    end    
  end
end