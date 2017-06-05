Apipie.configure do |config|
  config.app_name                = 'MeetylChallenge'
  config.api_base_url            = '/'
  config.doc_base_url            = '/doc'
  config.validate                = false
  config.default_version         = 'v1'
  # where is your API defined?
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/{[!concerns/]**/*,*}.rb"

  config.api_base_url['v1'] = '/v1'
  config.app_info['v1'] = 'Full Stack Developer – Code Challenge'
end
