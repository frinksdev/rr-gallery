require "test_helper"

class PhotofeedMailboxTest < ActionMailbox::TestCase
  # test "receive mail" do
  #   receive_inbound_email_from_mail \
  #     to: '"someone" <someone@example.com>',
  #     from: '"else" <else@example.com>',
  #     subject: "Hello world!",
  #     body: "Hello?"
  # end
  include ActiveJob::TestHelper
  test "Send attachments" do
    mail = Mail.new(
      from: 'jf.ortega496@gmail.com',
      to: 'b881ced07b7f02fcb7ad23e12e2b3de4@inbound.postmarkapp.com',
      subject: 'Image Upload unit test',
      body: 'Test',
    )
    mail.add_file(Rails.root.join("test/mailboxes/meme.jpg").to_s)

    inbound=receive_inbound_email_from_source(mail.to_s)
    #.tap(&:route)
    perform_enqueued_jobs
    pp Album.all
    assert inbound
  end

  test "Send attachments with zip" do
    mail = Mail.new(
      from: 'jf.ortega496@gmail.com',
      to: 'b881ced07b7f02fcb7ad23e12e2b3de4@inbound.postmarkapp.com',
      subject: 'Image Upload unit test',
      body: 'Test',
    )
    mail.add_file(Rails.root.join("test/mailboxes/meme.zip").to_s)

    inbound=receive_inbound_email_from_source(mail.to_s)
    #.tap(&:route)
    perform_enqueued_jobs
    #pp Album.all
    assert inbound
  end
end
