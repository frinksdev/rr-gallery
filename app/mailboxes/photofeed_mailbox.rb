class PhotofeedMailbox < ApplicationMailbox
  def process
    InboundMailJob.perform_later(inbound_email.id)
  end
end
