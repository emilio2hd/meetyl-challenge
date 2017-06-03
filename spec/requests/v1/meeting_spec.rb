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
          .to change { Invitation.where(invitee: invitee).count }.by(1)
      end
    end

    context 'and when there is invitation recurrence, but with recurrence has ended' do
      let(:recurrence_end_time) { Time.zone.parse('2017-05-28') }

      it 'does not create an invitation' do
        expect { post "/v1/users/#{creator.id}/meetings", params: { meeting: meeting_attributes } }
          .to_not change { Invitation.where(invitee: invitee).count }
      end
    end
  end
end