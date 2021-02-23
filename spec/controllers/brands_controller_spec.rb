require 'rails_helper'
RSpec.describe BrandsController do

  describe 'POST #create' do
    before :each do
      @super_admin = create(:user, email: 'sa@test.com', type: 'SuperAdmin')
      @admin = create(:user, email: 'admin@test.com', type: 'Admin')
      @contributor = create(:user, email: 'contributor@test.com', type: 'Contributor')
    end

    context 'when admin passes valid data' do
      it 'creates brand' do
        @company = create(:company, user_id: @admin.id)
        request.headers['Authorization'] = ActionController::HttpAuthentication::Token.encode_credentials(@admin.generate_jwt)
        post :create, params: {brand: {name: 'brand1', company_id: @company.id}}, format: :json
        expect(response).to have_http_status(:created)
        json_body = JSON.parse(response.body)
        expect(json_body["success"]).to eq(true)
        expect(Brand.last.name).to eq('brand1')
      end
    end
    context 'when admin passes invalid data' do
      it 'returns bad_request when name is blank' do
        request.headers['Authorization'] = ActionController::HttpAuthentication::Token.encode_credentials(@admin.generate_jwt)
        @company = create(:company, user_id: @admin.id)
        post :create, params: {brand: {name: '', company_id: @company.id}}, format: :json
        expect(response).to have_http_status(:bad_request)
        json_body = JSON.parse(response.body)
        expect(json_body["success"]).to eq(false)
      end
      it 'returns bad_request when company_id is blank' do
        request.headers['Authorization'] = ActionController::HttpAuthentication::Token.encode_credentials(@admin.generate_jwt)
        @company = create(:company, user_id: @admin.id)
        post :create, params: {brand: {name: 'brand1', company_id: nil}}, format: :json
        expect(response).to have_http_status(:bad_request)
        json_body = JSON.parse(response.body)
        expect(json_body["success"]).to eq(false)
      end      
    end
    context 'when no authroization header in the request' do
      it 'returns unauthorized' do
        @company = create(:company, user_id: @admin.id)
        post :create, params: {brand: {name: 'brand1', company_id: @company.id}}, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
    context 'when contributor passes valid data' do
      it 'returns forbidden' do
        request.headers['Authorization'] = ActionController::HttpAuthentication::Token.encode_credentials(@contributor.generate_jwt)
        @company = create(:company, user_id: @admin.id)
        post :create, params: {brand: {name: 'brand1', company_id: @company.id}}, format: :json
        expect(response).to have_http_status(:forbidden)
      end
    end
    context 'when super admin passes valid data' do
      it 'returns forbidden' do
        request.headers['Authorization'] = ActionController::HttpAuthentication::Token.encode_credentials(@super_admin.generate_jwt)
        @company = create(:company, user_id: @admin.id)
        post :create, params: {brand: {name: 'brand1', company_id: @company.id}}, format: :json
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'GET #index' do
    before :each do
      @super_admin = create(:user, email: 'sa@test.com', type: 'SuperAdmin')
      @admin = create(:user, email: 'admin@test.com', type: 'Admin')
      @contributor = create(:user, email: 'contributor@test.com', type: 'Contributor', created_by_id: @admin.id)
      @company = create(:company, user_id: @admin.id)
      @brand = create(:brand, user_id: @admin.id, company_id: @company.id)
      @brand_manager = create(:brand_manager, admin_id: @admin.id, brand_id: @brand.id, user_id: @contributor.id)
    end

    context 'when contributor gets all brands' do
      it 'returns brands' do
        request.headers['Authorization'] = ActionController::HttpAuthentication::Token.encode_credentials(@contributor.generate_jwt)
        get :index, format: :json
        expect(response).to have_http_status(:ok)
        json_body = JSON.parse(response.body)
        expect(json_body.include? 'brands').to eq(true)
        expect(JSON.parse(json_body['brands']).length).to eq(1)
      end
    end
    context 'when contributor tries to gets brands ' do
      it 'does not return other contributor brands' do
        @contributor2 = create(:user, email: 'contributors@test.com', type: 'Contributor')
        request.headers['Authorization'] = ActionController::HttpAuthentication::Token.encode_credentials(@contributor2.generate_jwt)
        get :index, format: :json
        expect(response).to have_http_status(:ok)
        json_body = JSON.parse(response.body)
        expect(json_body.include? 'brands').to eq(true)
        expect(JSON.parse(json_body['brands']).length).to eq(0)
      end
    end
    context 'when admin tries to gets brands ' do
      it 'does not return brands' do
        request.headers['Authorization'] = ActionController::HttpAuthentication::Token.encode_credentials(@admin.generate_jwt)
        get :index, format: :json
        expect(response).to have_http_status(:forbidden)
        json_body = JSON.parse(response.body)
        expect(json_body.include? 'brands').to eq(false)
      end
    end
    context 'when super-admin tries to gets brands ' do
      it 'does not return brands' do
        request.headers['Authorization'] = ActionController::HttpAuthentication::Token.encode_credentials(@admin.generate_jwt)
        get :index, format: :json
        expect(response).to have_http_status(:forbidden)
        json_body = JSON.parse(response.body)
        expect(json_body.include? 'brands').to eq(false)
      end
    end
  end
end