# frozen_string_literal: true

require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test 'should get login' do
    get static_pages_login_url
    assert_response :success
  end

  test 'should get user' do
    get static_pages_user_url
    assert_response :success
  end
end
