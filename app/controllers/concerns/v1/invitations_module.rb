module V1::InvitationsModule
  extend Apipie::DSL::Concern

  api :GET, '/users/:user_id/:resource_id', 'List user\'s invitation as invitee'
  api_version 'v1'
  def index; end

  api :GET, '/users/:user_id/:resource_id/:id', 'Retrieve information about a meeting or invitation if they have an invitation'
  error code: 404, desc: 'The invitation was not found'
  api_version 'v1'
  def show; end

  api :GET, '/users/:user_id/:resource_id/:id/status', 'Check the status of an invitation they received'
  error code: 404, desc: 'The invitation was not found'
  meta status: %w(pending accepted declined)
  api_version 'v1'
  def check_status; end

  api :PUT, '/users/:user_id/:resource_id/:id/execute', 'Take action on the invitation'
  error code: 400, desc: 'The invitation has validation errors'
  error code: 404, desc: 'The invitation was not found'
  api_version 'v1'
  param :invitation, Hash, desc: 'Invitation info', required: true do
    param :action, String, desc: 'Action to be executed', meta: %w(accept decline), required: true
  end
  def execute; end
end