require 'rails_helper'
RSpec.describe CompaniesController do

  describe 'POST #create' do
    before :each do
      @super_admin = create(:user, email: 'sa@test.com', type: 'SuperAdmin')
      @admin = create(:user, email: 'admin@test.com', type: 'Admin')
      @contributor = create(:user, email: 'contributor@test.com', type: 'Contributor')
    end

    context 'when admin passes valid data' do
      it 'creates company' do
        request.headers['Authorization'] = ActionController::HttpAuthentication::Token.encode_credentials(@admin.generate_jwt)
        post :create, params: {company: {name: 'comp1'}}, format: :json
        expect(response).to have_http_status(:created)
        json_body = JSON.parse(response.body)
        expect(json_body["success"]).to eq(true)
        expect(Company.last.name).to eq('comp1')
      end
    end
    context 'when admin passes invalid data' do
      it 'returns bad_request when name is blank' do
        request.headers['Authorization'] = ActionController::HttpAuthentication::Token.encode_credentials(@admin.generate_jwt)
        post :create, params: {company: {name: ''}}, format: :json
        expect(response).to have_http_status(:bad_request)
        json_body = JSON.parse(response.body)
        expect(json_body["success"]).to eq(false)
      end
    end
    context 'when no authroization header in the request' do
      it 'returns unauthorized' do
        post :create, params: {company: {name: 'comp1'}}, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
    context 'when contributor passes valid data' do
      it 'returns forbidden' do
        request.headers['Authorization'] = ActionController::HttpAuthentication::Token.encode_credentials(@contributor.generate_jwt)
        post :create, params: {company: {name: 'comp1'}}, format: :json
        expect(response).to have_http_status(:forbidden)
      end
    end
    context 'when super admin passes valid data' do
      it 'returns forbidden' do
        request.headers['Authorization'] = ActionController::HttpAuthentication::Token.encode_credentials(@super_admin.generate_jwt)
        post :create, params: {company: {name: 'comp1'}}, format: :json
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end