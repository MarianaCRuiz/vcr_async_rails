Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://job_storage:6379/1' } # localhost
end

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://job_storage:6379/1' } # localhost
end