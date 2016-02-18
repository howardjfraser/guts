require 'test_helper'

class UserMailerTest < ActionMailer::TestCase

  test "activation" do
    @brent = users(:brent)
    @brent.activation_token = "token"
    mail = UserMailer.activation(@brent)
    assert_equal "Account activation", mail.subject
    assert_equal [@brent.email], mail.to
    assert_equal ["noreply@example.com"], mail.from
    assert_match @brent.name, mail.body.encoded
    assert_match @brent.activation_token, mail.body.encoded
    assert_match CGI::escape(@brent.email), mail.body.encoded
  end

  test "password_reset" do
    @brent = users(:brent)
    @brent.reset_token = "token"
    mail = UserMailer.password_reset(@brent)
    assert_equal "Password reset", mail.subject
    assert_equal [@brent.email], mail.to
    assert_equal ["noreply@example.com"], mail.from
    assert_match @brent.name, mail.body.encoded
    assert_match @brent.reset_token, mail.body.encoded
    assert_match CGI::escape(@brent.email), mail.body.encoded
  end

end
