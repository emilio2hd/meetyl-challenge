require 'rails_helper'

RSpec.describe V1::MeetingsController, type: :controller do
  let(:valid_attributes) { attributes_for(:meeting) }
  let(:invalid_attributes) { valid_attributes.merge(place: nil) }
  let(:creator) { create(:user) }

  describe 'GET #index' do
    it 'assigns all meetings as @meetings' do
      Meeting.create! valid_attributes.merge(creator_id: creator.id)

      get :index, params: { user_id: creator.id }

      expect(json_response_body['meetings']).to_not be_empty
    end
  end

  describe 'GET #show' do
    it 'assigns the requested meeting as @meeting' do
      meeting = Meeting.create! valid_attributes.merge(creator_id: creator.id)

      get :show, params: { id: meeting.to_param, user_id: creator.id }

      expect(json_response_body['meeting']).to_not be_empty
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Meeting' do
        expect { post :create, params: { user_id: creator.id, meeting: valid_attributes } }.to change(Meeting, :count).by(1)
      end

      it 'assigns a newly created user' do
        post :create, params: { user_id: creator.id, meeting: valid_attributes }
        expect(json_response_body['meeting']).to_not be_empty
      end

      it 'should get http status as created' do
        post :create, params: { user_id: creator.id, meeting: valid_attributes }
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid params' do
      before { post :create, params: { user_id: creator.id, meeting: invalid_attributes } }

      it 'should get http status as bad_request' do
        expect(response).to have_http_status(:bad_request)
      end

      it 'should render errors' do
        expect(json_response_body['errors']).to_not be_empty
      end
    end
  end

  describe 'POST #invite' do
    let(:user) { create(:user) }
    let(:meeting) { create(:meeting) }
    let(:invite_params) { { id: meeting.id, user_id: meeting.creator_id, invitation: { invitee_id: user.id } } }

    it 'should create a new invitation' do
      expect { post :invite, params: invite_params } .to change(Invitation, :count).by(1)
    end

    it 'should return the invitation link' do
      post :invite, params: invite_params
      expect(json_response_body['invitation']).to_not be_empty
    end
  end

  describe 'GET #access' do
    let(:invitation) { create(:invitation) }
    let(:meeting_id) { invitation.meeting_id }
    let(:access_code) { invitation.access_code }

    before { get :access, params: { id: meeting_id, access_code: access_code } }

    shared_examples 'inaccessible meeting' do
      it { expect(response).to have_http_status(:not_found) }
    end

    context 'with valid meeting' do
      context 'with valid access code' do
        context 'invitee has not accepted the invitation' do
          it 'should be able to access the meeting' do
            expect(response).to have_http_status(:bad_request)
            expect(json_response_body['error']).to_not be_empty
          end
        end

        context 'invitee has accepted the invitation' do
          let(:invitation) { create(:invitation, status: :accepted) }

          it 'should be able to access the meeting' do
            expect(response).to have_http_status(:ok)
            expect(json_response_body['message']).to eq("Welcome #{invitation.invitee.name}!")
          end
        end
      end

      context 'with invalid access code' do
        let(:access_code) { '-1' }
        it_should_behave_like 'inaccessible meeting'
      end
    end

    context 'with invalid meeting' do
      context 'with valid access code' do
        let(:meeting_id) { '-1' }
        it_should_behave_like 'inaccessible meeting'
      end

      context 'with valid access code' do
        let(:meeting_id) { '-1' }
        let(:access_code) { '-1' }
        it_should_behave_like 'inaccessible meeting'
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_place) { 'new place' }
      let(:new_attributes) { valid_attributes.merge(place: new_place) }

      before do
        @meeting = Meeting.create! valid_attributes.merge(creator_id: creator.id)
        put :update, params: { id: @meeting.to_param, user_id: creator.id, meeting: new_attributes }
      end

      it 'updates the requested meeting' do
        @meeting.reload
        expect(@meeting.place).to eq(new_place)
      end

      it 'returns the update meeting' do
        expect(json_response_body['meeting']['place']).to eq(new_place)
      end

      it 'should get http status as ok' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid params' do
      let(:meeting) { Meeting.create! valid_attributes.merge(creator_id: creator.id) }

      before { put :update, params: { id: meeting.to_param, user_id: creator.id, meeting: invalid_attributes } }

      it 'should get http status as bad_request' do
        expect(response).to have_http_status(:bad_request)
      end

      it 'should render errors' do
        expect(json_response_body['errors']).to_not be_empty
      end
    end
  end
end
