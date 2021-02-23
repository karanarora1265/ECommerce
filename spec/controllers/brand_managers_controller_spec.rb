require 'rails_helper'
RSpec.describe BrandManagersController do

  describe 'POST #create' do
    before :each do
      @super_admin = create(:user, email: 'sa@test.com', type: 'SuperAdmin')
      @admin = create(:user, email: 'admin@test.com', type: 'Admin')
      @contributor = create(:user, email: 'contributor@test.com', type: 'Contributor', created_by_id: @admin.id)
    end

    context 'when admin passes valid data' do
      it 'creates brand' do
        @company = create(:company, user_id: @admin.id)
        @brand = create(:brand, user_id: @admin.id, company_id: @company.id)
        request.headers['Authorization'] = ActionController::HttpAuthentication::Token.encode_credentials(@admin.generate_jwt)
        post :create, params: {brand_manager: {user_id: @contributor.id, brand_id: @brand.id}}, format: :json
        expect(response).to have_http_status(:created)
        json_body = JSON.parse(response.body)
        expect(json_body["success"]).to eq(true)
        expect(BrandManager.last.user_id).to eq(@contributor.id)
        expect(BrandManager.last.admin_id).to eq(@admin.id)
        expect(BrandManager.last.brand_id).to eq(@brand.id)
      end
    end
    context 'when admin passes invalid data' do
      it 'returns bad_request when user_id is blank' do
        @company = create(:company, user_id: @admin.id)
        @brand = create(:brand, user_id: @admin.id, company_id: @company.id)
        request.headers['Authorization'] = ActionController::HttpAuthentication::Token.encode_credentials(@admin.generate_jwt)
        post :create, params: {brand_manager: {user_id: nil, brand_id: @brand.id}}, format: :json
        expect(response).to have_http_status(:bad_request)
        json_body = JSON.parse(response.body)
        expect(json_body["success"]).to eq(false)
      end
      it 'returns bad_request when brand_id is blank' do
        @company = create(:company, user_id: @admin.id)
        @brand = create(:brand, user_id: @admin.id, company_id: @company.id)
        request.headers['Authorization'] = ActionController::HttpAuthentication::Token.encode_credentials(@admin.generate_jwt)
        post :create, params: {brand_manager: {user_id: @contributor.id, brand_id: nil}}, format: :json
        expect(response).to have_http_status(:bad_request)
        json_body = JSON.parse(response.body)
        expect(json_body["success"]).to eq(false)
      end      
    end
    context 'when no authroization header in the request' do
      it 'returns unauthorized' do
        @company = create(:company, user_id: @admin.id)
        @brand = create(:brand, user_id: @admin.id, company_id: @company.id)
        post :create, params: {brand_manager: {user_id: @contributor.id, brand_id: @brand.id}}, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
    context 'when contributor passes valid data' do
      it 'returns forbidden' do
        request.headers['Authorization'] = ActionController::HttpAuthentication::Token.encode_credentials(@contributor.generate_jwt)
        @company = create(:company, user_id: @admin.id)
        @brand = create(:brand, user_id: @admin.id, company_id: @company.id)
        post :create, params: {brand_manager: {user_id: @contributor.id, brand_id: @brand.id}}, format: :json
        expect(response).to have_http_status(:forbidden)
      end
    end
    context 'when super admin passes valid data' do
      it 'returns forbidden' do
        request.headers['Authorization'] = ActionController::HttpAuthentication::Token.encode_credentials(@super_admin.generate_jwt)
        @company = create(:company, user_id: @admin.id)
        @brand = create(:brand, user_id: @admin.id, company_id: @company.id)
        post :create, params: {brand_manager: {user_id: @contributor.id, brand_id: @brand.id}}, format: :json
        expect(response).to have_http_status(:forbidden)
      end
    end
    context 'when admin tries to assign brand to other contributor' do
      it 'returns bad_request' do
        @contributor2 = create(:user, email: 'contributor2@test.com', type: 'Contributor')
        @company = create(:company, user_id: @admin.id)
        @brand = create(:brand, user_id: @admin.id, company_id: @company.id)
        request.headers['Authorization'] = ActionController::HttpAuthentication::Token.encode_credentials(@admin.generate_jwt)
        post :create, params: {brand_manager: {user_id: @contributor2.id, brand_id: @brand.id}}, format: :json
        expect(response).to have_http_status(:bad_request)
        json_body = JSON.parse(response.body)
        expect(json_body["success"]).to eq(false)
      end
    end
    context 'when admin tries to assign others brand to the contributor' do
      it 'returns bad_request' do
        @admin2 = create(:user, email: 'admin2@test.com', type: 'Admin')
        @company = create(:company, user_id: @admin2.id)
        @brand = create(:brand, user_id: @admin2.id, company_id: @company.id)
        request.headers['Authorization'] = ActionController::HttpAuthentication::Token.encode_credentials(@admin.generate_jwt)
        post :create, params: {brand_manager: {user_id: @contributor.id, brand_id: @brand.id}}, format: :json
        expect(response).to have_http_status(:bad_request)
        json_body = JSON.parse(response.body)
        expect(json_body["success"]).to eq(false)
      end
    end
  end
end