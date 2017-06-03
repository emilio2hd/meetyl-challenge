require 'rails_helper'

RSpec.describe V1::InvitationsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/v1/users/1/invitations').to route_to('v1/invitations#index', user_id: '1')
    end

    it 'routes to #show' do
      expect(get: '/v1/users/1/invitations/1').to route_to('v1/invitations#show', user_id: '1', id: '1')
    end

    it 'routes to #check_status' do
      expect(get: '/v1/users/1/invitations/1/status').to route_to('v1/invitations#check_status', user_id: '1', id: '1')
    end

    it 'routes to #execute' do
      expect(put: '/v1/users/1/invitations/1/execute').to route_to('v1/invitations#execute', user_id: '1', id: '1')
    end
  end
end