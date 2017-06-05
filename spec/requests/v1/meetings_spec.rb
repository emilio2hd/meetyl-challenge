require 'rails_helper'

RSpec.describe 'V1::Meetings', type: :request do
  context 'when I want create an meeting' do
    let(:creator) { create(:user) }
    let(:invitee) { create(:user) }
    let(:meeting_attributes) { attributes_for(:meeting, creator: creator, date: '2017-05-29') }
    let(:recurrence_start_time) { Time.zone.parse('2017-05-26T16:00') }
    let(:recurrence_end_time) { nil }
    let(:on_monday_recurrence) do
      build(:recurrence, start_time: recurrence_start_time, end_time: recurrence_end_time,
                         rule: IceCube::Rule.weekly.day(:monday))
    end

    before { create(:invitation_recurrence, creator: creator, user: invitee, rule: on_monday_recurrence) }

    it 'creates the meeting' do
      expect { post "/v1/users/#{creator.id}/meetings", params: { meeting: meeting_attributes } }
        .to change(Meeting, :count).by(1)
    end

    context 'and when there is invitation recurrence' do
      it 'creates the an invitation for the user that has the recurrence' do
        expect { post "/v1/users/#{creator.id}/meetings", params: { meeting: meeting_attributes } }
          .to change { Invitation.where(invitee: invitee, recurrent: true).count }.by(1)
      end
    end

    context 'and when there is invitation recurrence, but with recurrence has ended' do
      let(:recurrence_end_time) { Time.zone.parse('2017-05-28') }

      it 'does not create an invitation' do
        expect { post "/v1/users/#{creator.id}/meetings", params: { meeting: meeting_attributes } }
          .to_not change { Invitation.where(invitee: invitee, recurrent: false).count }
      end
    end
  end

  context 'when I want to retrieve information about a meeting' do
    let(:user) { create(:user) }

    context 'and I am the creator' do
      before do
        @meeting = create(:meeting, creator: user)
        get "/v1/users/#{user.id}/meetings/#{@meeting.id}"
      end

      it 'retrieves the meeting information as creator' do
        expect(response).to have_http_status(:ok)
        expect(json_response_body['meeting']['id']).to eq(@meeting.id)
        expect(json_response_body['meeting']['creator']['id']).to eq(user.id)
      end
    end

    context 'and I am an invitee' do
      before do
        @meeting = create(:meeting)
        create(:invitation, meeting: @meeting, invitee: user)
        get "/v1/users/#{user.id}/meetings/#{@meeting.id}"
      end

      it 'retrieves the meeting information as invitee' do
        expect(response).to have_http_status(:ok)
        expect(json_response_body['meeting']['id']).to eq(@meeting.id)
        expect(json_response_body['meeting']['creator']['id']).to_not eq(user.id)
      end
    end
  end

  context 'when I, as invitee, want to access the meeting' do
    let(:meeting) { create(:meeting) }
    let(:invitation) { create(:invitation, meeting: meeting) }

    context 'and the invitation is not accepted' do
      it 'does not allow access to the meeting' do
        get "/v1/meetings/#{meeting.id}/#{invitation.access_code}"
        expect(response).to have_http_status(:bad_request)
        expect(json_response_body['error']).to eq('You must accept the invitation before access the meeting')
      end
    end

    context 'and the invitation is already accepted' do
      it 'allows access to the meeting' do
        invitation.accepted!

        get "/v1/meetings/#{meeting.id}/#{invitation.access_code}"
        expect(response).to have_http_status(:ok)
        expect(json_response_body['message']).to start_with('Welcome')
      end
    end
  end

  context 'when I invite an user to the meeting' do
    let(:user) {  create(:user) }
    let(:invitee) { create(:user) }
    let(:meeting) { create(:meeting, creator: user) }

    context 'and there is not recurrence' do
      let(:invitation_params) { { invitation: { invitee_id: invitee.id } } }

      before do
        expect { post "/v1/users/#{user.id}/meetings/#{meeting.id}/invite", params: invitation_params }
          .to change { Invitation.where(invitee: invitee).count }.by(1)
          .and change { InvitationRecurrence.where(user: invitee).count }.by(0)
      end

      it 'creates a new invitations' do
        expect(response).to have_http_status(:created)
      end

      it 'generates an unique url for the invitation' do
        expect(json_response_body['invitation']['meeting_link']).to_not be_empty
      end
    end

    context 'and there is recurrence' do
      let(:invitation_params) do
        { invitation: { invitee_id: invitee.id, recurrence: { type: 'monthly', options: { day_of_week: { tuesday: [1, -1] } } } } }
      end

      before do
        expect { post "/v1/users/#{user.id}/meetings/#{meeting.id}/invite", params: invitation_params }
          .to change { Invitation.where(invitee: invitee).count }.by(1)
          .and change { InvitationRecurrence.where(user: invitee).count }.by(1)
      end

      it 'creates a new invitations' do
        expect(response).to have_http_status(:created)
      end

      it 'generates an unique url for the invitation' do
        expect(json_response_body['invitation']['meeting_link']).to_not be_empty
      end

      it 'creates a recurrence that match with "Monthly on the 1st Tuesday and last Tuesday"' do
        recurrence = InvitationRecurrence.find_by(user: invitee)
        expect(recurrence.rule.to_s).to eq('Monthly on the 1st Tuesday and last Tuesday')
      end
    end
  end
end