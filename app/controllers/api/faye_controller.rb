class API::FayeController < API::BaseController

  rescue_from NameError do |e| respond_with_error(e, status: 400) end

  def subscribe
    raise ActiveRecord::RecordNotFound unless channel_model
    authorize! :show, channel_model
    render json: PrivatePub.subscription(channel: params[:channel], server: ENV['FAYE_URL'])
  end

  def who_am_i
    render json: current_user, serializer: UserSerializer
  end

  private

  def channel_model
    @channel_model ||= channel_class.find_by(key: channel_key)
  end

  def channel_class
    @channel_class ||= channel_parts.first.to_s.classify.constantize
  end

  def channel_key
    @channel_key   ||= channel_parts.last
  end

  def channel_parts
    @channel_parts ||= params[:channel].split('/').reject(&:blank?).first.split('-')
  end
end
