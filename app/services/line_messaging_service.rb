# frozen_string_literal: true

require 'singleton'

# The LineMessagingService class is a singleton that provides access to the Line Messaging API client.
# It ensures that only one instance of the client is created and reused throughout the application.
class LineMessagingService
  include Singleton

  # Creates or retrieves the Line Messaging API client instance.
  #
  # The client is configured using environment variables for the Line channel.
  #
  # Returns:
  #   [Line::Bot::Client] The Line Messaging API client instance.
  #
  # Example:
  #   client = LineMessagingService.instance.call
  #
  def call
    @call ||= Line::Bot::Client.new do |config|
      config.channel_id = ENV['LINE_CHANNEL_MESSAGE_ID']
      config.channel_secret = ENV['LINE_CHANNEL_MESSAGE_SECRET']
      config.channel_token = ENV['LINE_CHANNEL_MESSAGE_TOKEN']
    end
  end
end
