if ENV['REDIS_URL_SIDEKIQ']
  Sidekiq.configure_client do |config|
    config.redis = { url: ENV['REDIS_URL_SIDEKIQ'], network_timeout: 5 }
  end
  Sidekiq.configure_server do |config|
    config.redis = { url: ENV['REDIS_URL_SIDEKIQ'], network_timeout: 5 }
  end
end