class WebhookJob < ApplicationJob
  queue_as :medium

  # Retry up to 3 times with exponential backoff
  retry_on StandardError,     wait: :exponentially_longer, attempts: 3  

  # job retry and timeout 10 seconds - altough timeout is probably not needed
  sidekiq_options retry: 3, timeout: 10

  #  There are 3 types of webhooks, account, inbox and agent_bot
  def perform(url, payload, webhook_type = :account_webhook)
    Webhooks::Trigger.execute(url, payload, webhook_type)
  end
end
