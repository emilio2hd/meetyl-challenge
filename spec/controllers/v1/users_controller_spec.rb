require 'rails_helper'

RSpec.describe V1::UsersController, type: :controller do
  let(:valid_attributes) { attributes_for(:user) }
  let(:invalid_attributes) { attributes_for(:user).merge(name: nil) }

  describe 'GET #index' do
    it 'assigns all users as @users' do
      User.create! valid_attributes

      get :index, params: {}

      expect(json_response_body['users']).to_not be_empty
    end
  end

  describe 'GET #show' do
    it 'assigns the requested user as @user' do
      user = User.create! valid_attributes

      get :show, params: { id: user.to_param }

      expect(json_response_body['user']).to_not be_empty
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new User' do
        expect { post :create, params: { user: valid_attributes } }.to change(User, :count).by(1)
      end

      it 'assigns a newly created user' do
        post :create, params: { user: valid_attributes }
        expect(json_response_body['user']).to_not be_empty
      end

      it 'should get http status as created' do
        post :create, params: { user: valid_attributes }
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid params' do
      before { post :create, params: { user: invalid_attributes } }

      it 'should get http status as bad_request' do
        expect(response).to have_http_status(:bad_request)
      end

      it 'should render errors' do
        post :create, params: { user: invalid_attributes }
        expect(json_response_body['errors']).to_not be_empty
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_name) { "#{valid_attributes[:name]} [edited]" }
      let(:new_attributes) { valid_attributes.merge(name: new_name) }

      before do
        @user = User.create! valid_attributes
        put :update, params: { id: @user.to_param, user: new_attributes }
      end

      it 'updates the requested user' do
        @user.reload
        expect(@user.name).to eq(new_name)
      end

      it 'returns the update user' do
        expect(json_response_body['user']['name']).to eq(new_name)
      end

      it 'should get http status as ok' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid params' do
      let(:user) { User.create! valid_attributes }

      before { put :update, params: { id: user.to_param, user: invalid_attributes } }

      it 'should get http status as bad_request' do
        expect(response).to have_http_status(:bad_request)
      end

      it 'should render errors' do
        expect(json_response_body['errors']).to_not be_empty
      end
    end
  end
end