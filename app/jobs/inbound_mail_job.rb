require "rubygems"
require "zip"

class InboundMailJob < ApplicationJob
  queue_as :default

  def perform(mail_id)
    inbound_email = ActionMailbox::InboundEmail.find(mail_id)
    mail = Mail.new(inbound_email.source)

    photo = Album.new(title: mail.subject)

    photo.save!
    mail.attachments.each do |att|
      if att.content_type.match?(/application\/zip;/)

        tempfile = Tempfile.new("tmp", encoding: "ascii-8bit")
        tempfile.write att.decoded
        tempfile.close

        Zip::File.open(tempfile) do |zip_file|
          zip_file.glob("**/**/*.{png,jpg,jpeg,gif}") do |f|
            file = Paperclip.io_adapters.for(StringIO.new(f.get_input_stream.read))
            file.original_filename = f.name
            photo.attachments.create(image: file)
          end
        end
      else
        file = Paperclip.io_adapters.for(StringIO.new(att.decoded))
        file.original_filename = att.filename

        photo.attachments.create(image: file)
      end
    end
  end
end
