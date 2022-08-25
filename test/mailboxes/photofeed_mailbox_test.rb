require "test_helper"

class PhotofeedMailboxTest < ActionMailbox::TestCase
  include ActiveJob::TestHelper
  test "Send one attachment" do
    mail = Mail.new(
      subject: "Image Upload Test"
    )
    mail.add_file(Rails.root.join("test/mailboxes/warframe1.png").to_s)

    receive_inbound_email_from_source(mail.to_s)

    assert_difference "Album.count" do
      perform_enqueued_jobs
    end

    album = Album.last

    assert_equal "Image Upload Test", album.title

    assert_equal 1, album.attachments.count
  end

  test "Send zip attachment" do
    mail = Mail.new(
      subject: "Zip Upload Test"
    )
    mail.add_file(Rails.root.join("test/mailboxes/warframe.zip").to_s)

    receive_inbound_email_from_source(mail.to_s)

    assert_difference "Album.count" do
      perform_enqueued_jobs
    end

    album = Album.last

    assert_equal "Zip Upload Test", album.title

    assert_equal 4, album.attachments.count
  end

  test "send multiple images" do
    mail = Mail.new(
      subject: "Images Upload Test"
    )
    mail.add_file(Rails.root.join("test/mailboxes/warframe1.png").to_s)
    mail.add_file(Rails.root.join("test/mailboxes/warframe2.png").to_s)
    mail.add_file(Rails.root.join("test/mailboxes/warframe3.png").to_s)
    mail.add_file(Rails.root.join("test/mailboxes/warframe4.png").to_s)

    receive_inbound_email_from_source(mail.to_s)

    assert_difference "Album.count" do
      perform_enqueued_jobs
    end

    album = Album.last

    assert_equal "Images Upload Test", album.title

    assert_equal 4, album.attachments.count
  end

  test "send multiple zip" do
    mail = Mail.new(
      subject: "Multiple Zip Upload Test"
    )
    mail.add_file(Rails.root.join("test/mailboxes/warframe.zip").to_s)
    mail.add_file(Rails.root.join("test/mailboxes/warframe_f.zip").to_s)
    receive_inbound_email_from_source(mail.to_s)

    assert_difference "Album.count" do
      perform_enqueued_jobs
    end

    album = Album.last

    assert_equal "Multiple Zip Upload Test", album.title

    assert_equal 8, album.attachments.count
  end

  test "send multiple files images/zip" do
    mail = Mail.new(
      subject: "Multiple Files Upload Test"
    )
    mail.add_file(Rails.root.join("test/mailboxes/warframe1.png").to_s)
    mail.add_file(Rails.root.join("test/mailboxes/warframe2.png").to_s)
    mail.add_file(Rails.root.join("test/mailboxes/warframe.zip").to_s)
    mail.add_file(Rails.root.join("test/mailboxes/warframe_f.zip").to_s)

    receive_inbound_email_from_source(mail.to_s)

    assert_difference "Album.count" do
      perform_enqueued_jobs
    end

    album = Album.last

    assert_equal "Multiple Files Upload Test", album.title

    assert_equal 10, album.attachments.count
  end
end
