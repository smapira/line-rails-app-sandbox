# frozen_string_literal: true

# The LineMessageApiController class handles Line message callbacks and responses within the Rails application.
class LineMessageApiController < ApplicationController
  protect_from_forgery except: [:callback]

  # Handles Line message callbacks, validates the signature, and processes received events.
  #
  # This method reads the request body, validates the Line signature, and processes the received Line events.
  #
  def callback
    body = request.body.read
    client = LineMessagingService.instance.call

    signature = request.env['HTTP_X_LINE_SIGNATURE']
    head 400 do 'Bad Request' end unless client.validate_signature(body, signature)

    events = client.parse_events_from(body)
    response_messaging_api client, events
    head :ok
  end

  private

  # Pushes a received message response to the Line user.
  def push_receive_message(client, event)
    user = User.find_by(provider: :line, uid: event['source']['userId'])
    request_message = event['message']['text']
    message = build_response("Received message: #{request_message} from user: #{user.name}")
    client.reply_message(event['replyToken'], message)
  end

  # Pushes a follow event response to the Line user.
  def push_follow_message(client, event)
    logger.info 'Line::Bot::Event::Follow'
    fetch_user(event['source']['userId'])
    message = build_response('Starting follow')
    client.reply_message(event['replyToken'], message)
  end

  # Processes Line events and sends appropriate responses.
  def response_messaging_api(client, events)
    events.each do |event|
      case event
      when Line::Bot::Event::Message
        logger.info 'Line::Bot::Event::Message'
        case event.type
        when Line::Bot::Event::MessageType::Text
          push_receive_message client, event
        else
          # Add handling for other message types here
        end
      when Line::Bot::Event::Follow
        push_follow_message client, event
      else
        # Add handling for other event types here
      end
    end
  end

  # Fetches Line user information using the Line user ID and creates or retrieves the user.
  def fetch_user(line_user_id)
    user = User.find_or_initialize_by(provider: :line, uid: line_user_id)
    if user.email.blank?
      email = "#{line_user_id}-line@example.com"
      user = User.create!(provider: :line,
                          uid: line_user_id,
                          email:,
                          password: Devise.friendly_token[0, 20])
    end
    user
  end

  # Builds a Line message response with the provided text.
  def build_response(message)
    {
      type: 'text',
      text: message
    }
  end
end
