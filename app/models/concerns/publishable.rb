module Publishable
  extend ActiveSupport::Concern

  included do
    def self.publish!(publishable)
      new(publishable).publish!
    end
  end

  def message_channel
    raise NotImplementedError.new
  end

  def serializer
    "#{self.class.to_s}Serializer".constantize
  end

  def publish!
    return false unless ENV['FAYE_ENABLED']
    publisher = ENV['DELAY_FAYE'] ? PrivatePub.delay(priority: 10) : PrivatePub
    publisher.publish_to(message_channel, serializer.new(self).as_json)
  end
end
