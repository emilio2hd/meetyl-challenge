require 'rails_helper'

RSpec.describe 'V1::Invitations', type: :request do
  let(:invitee) { create(:user) }

  context 'when I am invited to a meeting and the action' do
    let(:meeting) { nil }
    let(:invitation) { create(:invitation, invitee: invitee, meeting: meeting) }
    let(:action_params) { { invitation: { action: 'accept' } } }

    context 'accept is take' do
      context 'when the meeting does not have maximum number of people' do
        let(:meeting) { create(:meeting) }

        it 'changes the invitation status and return it' do
          expect { put "/v1/users/#{invitee.id}/invitations/#{invitation.id}/execute", params: action_params }
            .to change { Invitation.find_by(id: invitation.id).status }
            .from(a_string_matching(/pending/)).to(a_string_matching(/accepted/))

          expect(response).to have_http_status(:ok)
          expect(json_response_body['invitation']['status']).to eq('accepted')
        end

        it 'does not update the meeting participants count ' do
          expect { put "/v1/users/#{invitee.id}/invitations/#{invitation.id}/execute", params: action_params }
            .to_not change { Meeting.find_by(id: meeting.id).participants_count }
        end
      end

      context 'when the meeting has maximum number of people, but is not fully booked' do
        let(:meeting) { create(:meeting, maximum_participants: 10, participants_count: 5) }

        it 'updates the meeting participants count ' do
          expect { put "/v1/users/#{invitee.id}/invitations/#{invitation.id}/execute", params: action_params }
            .to change { Meeting.find_by(id: meeting.id).participants_count }.by(1)

          expect(response).to have_http_status(:ok)
          expect(json_response_body['invitation']['status']).to eq('accepted')
        end

        it 'changes the invitation status from pending to accepted' do
          expect { put "/v1/users/#{invitee.id}/invitations/#{invitation.id}/execute", params: action_params }
            .to change { Invitation.find_by(id: invitation.id).status }
            .from(a_string_matching(/pending/)).to(a_string_matching(/accepted/))
        end
      end

      context 'when the meeting has maximum number of people and is fully booked' do
        let(:meeting) { create(:meeting, maximum_participants: 2, participants_count: 2) }

        it 'does not update the meeting participants count and return validation error' do
          expect { put "/v1/users/#{invitee.id}/invitations/#{invitation.id}/execute", params: action_params }
            .to_not change { Meeting.find_by(id: meeting.id).participants_count }

          expect(response).to have_http_status(:bad_request)
          expect(json_response_body['errors']['maximum_participants'])
            .to eq(['Meeting overbooked, maximum participants has been reached'])
        end

        it 'does not change the invitation status' do
          expect { put "/v1/users/#{invitee.id}/invitations/#{invitation.id}/execute", params: action_params }
            .to_not change { Invitation.find_by(id: invitation.id).status }
        end
      end

      context "when I've accepted an recurrent invitation to a meeting and I try accept another" do
        let(:meeting) { create(:meeting) }
        let(:duplicated_invitation) { create(:invitation, invitee: invitee, meeting: meeting, recurrent: true) }

        before { create(:recurrent_accepted_invitation, invitee: invitee, meeting: meeting) }

        it 'does not change the invitation status' do
          expect { put "/v1/users/#{invitee.id}/invitations/#{duplicated_invitation.id}/execute", params: action_params }
            .to_not change { Invitation.find_by(id: duplicated_invitation.id).status }

          expect(response).to have_http_status(:bad_request)
          expect(json_response_body['errors']['meeting'])
            .to eq(['You have already accepted the invitation for this meeting'])
        end
      end
    end

    context 'unknown is take' do
      let(:invitation) { create(:invitation, invitee: invitee) }
      let(:action_params) { { invitation: { action: 'unknown' } } }

      it 'does not change the invitation status and return validation error' do
        expect { put "/v1/users/#{invitee.id}/invitations/#{invitation.id}/execute", params: action_params }
          .to_not change { Invitation.find_by(id: invitation.id).status }

        expect(response).to have_http_status(:bad_request)
        expect(json_response_body['errors']['action']).to eq(["action 'unknown' not available"])
      end
    end
  end

  context 'when I am invited to a meeting' do
    context 'and I want to know the status of the invitation' do
      let(:invitation) { create(:accepted_invitation, invitee: invitee) }

      it 'returns the invitation status' do
        get "/v1/users/#{invitee.id}/invitations/#{invitation.id}/status"

        expect(response).to have_http_status(:ok)
        expect(json_response_body['invitation']['status']).to eq('accepted')
      end
    end
  end
end