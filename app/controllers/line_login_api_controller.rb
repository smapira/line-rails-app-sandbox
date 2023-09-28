# frozen_string_literal: true

# == LineLoginApiController
#
# This class handles Line login integration within the Rails application.
#
class LineLoginApiController < ApplicationController
  # Handles the Line login process by generating a random state, constructing the authorization URL,
  # and redirecting the user to Line's login page.
  #
  # For more details, refer to: https://developers.line.biz/ja/docs/line-login/integrate-line-login/#making-an-authorization-request
  #
  def login
    session[:state] = SecureRandom.urlsafe_base64
    authorization_url = assemble_authorization_url(session[:state])

    redirect_to authorization_url, allow_other_host: true
  end

  # The callback endpoint for Line login. Verifies the received state, fetches user information,
  # and either signs in the user or redirects with an error message.
  def callback
    if params[:state] != session[:state]
      logger.error { 'Invalid access attempt' }
      redirect_to root_url, notice: 'Invalid access attempt'
      return
    end

    user = fetch_user
    if user.save
      logger.error { 'Logged in successfully' }
      sign_in(:user, user)

      client = LineMessagingService.instance.call
      message = {
        type: 'text',
        text: 'Logged in successfully'
      }
      client.push_message(user.uid, message)

      redirect_to static_pages_user_url, notice: 'Logged in successfully'
    else
      logger.error { 'Login failed' }
      redirect_to root_url, notice: 'Login failed'
    end
  end

  private

  # Retrieves Line user information by verifying the Line ID token.
  #
  # For more details, refer to: https://developers.line.biz/ja/docs/line-login/verify-id-token/
  #
  def get_line_user_information(code)
    line_user_id_token = get_line_user_id_token(code)
    return nil if line_user_id_token.blank?

    url = 'https://api.line.me/oauth2/v2.1/verify'
    options = {
      body: {
        id_token: line_user_id_token,
        client_id: ENV['LINE_CHANNEL_ID']
      }
    }

    response = Typhoeus::Request.post(url, options)

    return unless response.code == 200

    JSON.parse(response.body)
  end

  # Obtains the Line user ID token using the provided code.
  #
  # For more details, refer to: https://developers.line.biz/ja/reference/line-login/#issue-access-token
  #
  def get_line_user_id_token(code)
    url = 'https://api.line.me/oauth2/v2.1/token'

    options = {
      headers: {
        'Content-Type' => 'application/x-www-form-urlencoded'
      },
      body: {
        grant_type: 'authorization_code',
        code:,
        redirect_uri: ENV['LINE_LOGIN_CALLBACK_URL'],
        client_id: ENV['LINE_CHANNEL_ID'],
        client_secret: ENV['LINE_CHANNEL_SECRET']
      }
    }
    response = Typhoeus::Request.post(url, options)

    return unless response.code == 200

    JSON.parse(response.body)['id_token']
  end

  # Assembles the Line authorization URL with the required parameters.
  def assemble_authorization_url(state)
    base_authorization_url = 'https://access.line.me/oauth2/v2.1/authorize'
    response_type = 'code'
    client_id = ENV['LINE_CHANNEL_ID']
    redirect_uri = CGI.escape(ENV['LINE_LOGIN_CALLBACK_URL'])
    scope = 'profile%20openid'

    "#{base_authorization_url}?response_type=#{response_type}&client_id=#{client_id}&redirect_uri=#{redirect_uri}&state=#{state}&scope=#{scope}"
  end

  # Fetches Line user information using the code obtained from the callback and creates or retrieves the user.
  def fetch_user
    line_user = get_line_user_information(params[:code])
    line_user_id = line_user['sub']
    line_user['picture']
    user = User.find_or_initialize_by(provider: :line, uid: line_user_id)
    if user.email.blank?
      email = line_user['email'] || "#{line_user_id}-line@example.com"
      user = User.create!(provider: :line,
                          uid: line_user_id,
                          email:,
                          name: line_user['name'],
                          password: Devise.friendly_token[0, 20])
    end
    user
  end
end
