class API::BaseController < ActionController::Base
  include CurrentUserHelper
  include ::ProtectedFromForgery
  before_filter :require_authenticated_user

  skip_after_filter :intercom_rails_auto_include

  rescue_from ActionController::UnpermittedParameters do |e| respond_with_error(e, status: 400) end
  rescue_from CanCan::AccessDenied                    do |e| respond_with_error(e, status: 403) end
  rescue_from ActiveRecord::RecordNotFound            do |e| respond_with_error(e, status: 404) end

  protected

  def permitted_params
    @permitted_params ||= PermittedParams.new(params, current_user)
  end

  def require_authenticated_user
    head 401 unless current_user
  end

  def authenticate_user_by_email_api_key
    user_id = request.headers['Loomio-User-Id']
    key = request.headers['Loomio-Email-API-Key']
    @current_user = User.where(id: user_id, email_api_key: key).first
  end

  private

  def respond_with_error(e, status:)
    render json: error_json(e), root: false, status: status
  end

  def error_json(e)
    case e
    when Exception then e.class.to_s
    when Hash then      e.as_json
    end
  end
end
