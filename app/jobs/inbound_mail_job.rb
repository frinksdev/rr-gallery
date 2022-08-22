class InboundMailJob < ApplicationJob
  queue_as :default

  def perform(mail_id)
    inbound_email = ActionMailbox::InboundEmail.find(mail_id)
    mail = Mail.new(inbound_email.source)

    photo = Album.new(title: mail.subject)
    
    mail.attachments.each do |att|
      #photo.images.attach(:io => StringIO.new(att.decoded),
      #                    :filename => att.filename,
      #                    :content_type => att.content_type)
      if att.content_type.match(/application\/zip\;/)
        puts "Archivo Zip detectado"
      else
        file = Paperclip.io_adapters.for(StringIO.new(att.decoded))
        file.original_filename = att.filename

        photo.images = file
      end
    end
    
    photo.save!
    puts photo
  end
end
