require 'rails_helper'

RSpec.describe V1::MeetingsController, type: :routing do
  describe 'routing' do

    it 'routes to #index' do
      expect(get: '/v1/users/1/meetings').to route_to('v1/meetings#index', user_id: '1')
    end

    it 'routes to #show' do
      expect(get: '/v1/users/1/meetings/1').to route_to('v1/meetings#show', user_id: '1', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/v1/users/1/meetings').to route_to('v1/meetings#create', user_id: '1')
    end

    it 'routes to #update via PUT' do
      expect(put: '/v1/users/1/meetings/1').to route_to('v1/meetings#update', user_id: '1', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/v1/users/1/meetings/1').to route_to('v1/meetings#update', user_id: '1', id: '1')
    end
  end
end
