class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user

private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def validate_user
    user_id = request.headers['X-Sfdc-UserId']
    org_id = request.headers['X-Sfdc-OrganizationId']

    # TODO: 認証...
    user = User.where(user_id: user_id, org_id: org_id, is_valid: true).first
    render :text => 'invalid user.' if user.blank?
  end
end
