class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :reset_session
  before_action :load_schema, unless: -> { Hours.single_tenant_mode? }
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_locale

  protected

  def default_url_options
    if Rails.env.development?
      { host: "hours.localhost"}
    else
      {}
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:accept_invitation).
      concat([:first_name, :last_name])
  end

  def authenticate_inviter!
    current_user || authenticate_user!
  end

  def after_invite_path_for(*)
    users_path
  end

  private

  helper_method :current_subdomain, :current_user_owner?

  def current_subdomain
    @current_subdomain ||=
      current_account.subdomain unless Hours.single_tenant_mode?
  end

  def current_user_owner?
    current_account.owner == current_user unless Hours.single_tenant_mode?
  end

  def current_account
    @current_account ||= Account.find_by(subdomain: request.subdomain)
  end

  def load_schema
    Apartment::Tenant.switch("public")
    return unless request.subdomain.present?
    # puts 'request', request
    # puts 'request.host', request.host
    # puts 'request.subdomain', request.subdomain
    # puts 'request.subdomains.first', request.subdomains.first
    # puts 'request.subdomains', request.subdomains.class

    if current_account
      Apartment::Tenant.switch(request.subdomain)
    else
      # redirect_to root_url(subdomain: false)
      puts "redirecting to root_url"
      redirect_to root_url
    end
  end

  def set_locale
    I18n.locale =
      http_accept_language.compatible_language_from(I18n.available_locales)
  end
end
