Rollbar.configure do |config|
  config.access_token = ENV['ROLLBAR_ACCESS_TOKEN']

  # Here we'll disable in 'test':
  if Rails.env.production?
    config.enabled = true
  end

  config.environment = ENV['ROLLBAR_ENV'] || Rails.env

  config.exception_level_filters.merge!({
    'ActiveRecord::RecordNotFound' => 'ignore',
    'ActionController::RoutingError' => 'ignore',
    'NoMethodError' => 'critical'
  })
end
