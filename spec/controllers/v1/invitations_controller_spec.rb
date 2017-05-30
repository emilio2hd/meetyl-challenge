require 'rails_helper'

RSpec.describe V1::InvitationsController, type: :controller do
  let(:invitee) { create(:user) }

  describe 'GET #index' do
    before do
      create_list(:invitation, 3)
      create_list(:invitation, 5, invitee: invitee)
    end

    it 'assigns all user invitations' do
      get :index, params: { user_id: invitee.id }

      expect(json_response_body['invitations']).to_not be_empty
      expect(json_response_body['invitations'].size).to eq(5)
    end
  end

  describe 'GET #show' do
    let(:invitee) { create(:user) }
    let(:invitation) { create(:invitation, invitee: invitee) }

    it 'assigns the requested user invitation' do
      get :show, params: { id: invitation.to_param, user_id: invitee.id }

      expect(json_response_body['invitation']).to_not be_empty
    end
  end

  describe 'GET #check_status' do
    let(:invitee) { create(:user) }
    let(:invitation) { create(:invitation, invitee: invitee) }

    it 'assigns the status of the requested user invitation' do
      get :check_status, params: { id: invitation.to_param, user_id: invitee.id }

      expect(json_response_body['invitation']['status']).to_not be_empty
    end
  end

  describe 'PATCH #execute' do
    let(:invitee) { create(:user) }
    let(:invitation) { create(:invitation, invitee: invitee) }

    context 'with valid params' do
      it 'should execute invitation status' do
        get :execute, params: { id: invitation.to_param, user_id: invitee.id, invitation: { action: 'accept' } }
        invitation.reload
        expect(response).to have_http_status(:ok)
        expect(invitation.status).to eq('accepted')
      end

      context 'when action is not executed' do
        before do
          form = InvitationActionForm.new
          form.errors.add(:base, :some_error)
          result = Invitation::Action::ActionResult.new(form, true)

          action_mock = double(Invitation::Action::Accept)
          allow(action_mock).to receive(:execute!).and_return(result)
          expect(Invitation::ActionLocator).to receive(:lookup).with('accept').and_return(action_mock)
        end

        it 'should render the errors' do
          get :execute, params: { id: invitation.to_param, user_id: invitee.id, invitation: { action: 'accept' } }

          expect(response).to have_http_status(:bad_request)
          expect(json_response_body['errors']).to_not be_empty
        end
      end
    end

    context 'with invalid params' do
      it 'should return errors' do
        get :execute, params: { id: invitation.to_param, user_id: invitee.id, invitation: { action: 'unknow' } }
        expect(response).to have_http_status(:bad_request)
        expect(json_response_body['errors']).to_not be_empty
      end
    end
  end
end
