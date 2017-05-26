require 'rails_helper'

RSpec.describe 'V1::Users', type: :request do
  describe 'POST /users' do
    context 'with valid params' do
      let(:valid_attributes) { attributes_for(:user) }

      before { expect { post v1_users_path, params: { user: valid_attributes } }.to change(User, :count).by(1) }

      it 'should contains the link to the resource details' do
        user = User.new(id: json_response_body['user']['id'])
        expect(json_response_body['user']['links']['self']).to eq(v1_user_path(user))
      end
    end

    context 'with invalid params' do
      let(:invalid_attributes) { { name: nil } }

      before { expect { post v1_users_path, params: { user: invalid_attributes } }.to_not change(User, :count) }

      it 'should contains errors' do
        expect(json_response_body['errors'].count).to eq(1)
      end
    end
  end

  describe 'GET /users' do
    before(:all) { create_list(:user, 5) }
    before { get v1_users_path }

    it 'should return a list of users' do
      expect(json_response_body['users'].count).to eq(5)
    end
  end

  describe 'GET /users/:id' do
    before(:all) { @user = create(:user) }
    before { get v1_user_path(@user) }

    it 'should return user detail' do
      expect(json_response_body['user']).to_not be_empty
    end
  end

  describe 'PUT /users/:id' do
    before(:all) { @user = create(:user) }

    let(:new_name) { "#{@user.name} [edited]" }

    before do
      expect { put v1_user_path(@user), params: { user: { name: new_name } } }.to_not change(User, :count)
    end

    it 'should update the user' do
      @user.reload
      expect(@user.name).to eq(new_name)
    end

    it 'should return user detail' do
      expect(json_response_body['user']).to_not be_empty
    end
  end
end
