module V1::UsersModule
  extend Apipie::DSL::Concern

  api :GET, '/:resource_id', 'List users'
  api_version 'v1'
  def index; end

  api :POST, '/:resource_id', 'Add a new user'
  error code: 400, desc: 'The user has validation errors'
  api_version 'v1'
  param :user, Hash, desc: 'User info', required: true do
    param :name, String, desc: 'User\'s name', required: true
  end
  def create; end

  api :GET, '/:resource_id/:id', 'Get user information'
  error code: 404, desc: 'The user was not found'
  api_version 'v1'
  def show; end

  api :PUT, '/:resource_id/:id', 'Update user information'
  error code: 400, desc: 'The user has validation errors'
  error code: 404, desc: 'The user was not found'
  api_version 'v1'
  param :user, Hash, desc: 'User info', required: true do
    param :name, String, desc: 'User\'s name', required: true
  end
  def update; end
end