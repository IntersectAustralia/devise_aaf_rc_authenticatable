class Devise::AafRcSessionsController < Devise::SessionsController
  unloadable
  prepend_before_filter :require_no_authentication, :only => [:aaf_new, :aaf_create]
  prepend_before_filter :allow_params_authentication!, :only => :aaf_create

  def aaf_new
    config = YAML.load(ERB.new(File.read(::Devise.aaf_rc_config || "#{Rails.root}/config/aaf_rc.yml")).result)[Rails.env]

    redirect_to config['aaf_rc_login_url']
  end

  def aaf_create
    self.resource = warden.authenticate!(auth_options)
    set_flash_message(:notice, :signed_in) if is_navigational_format?
    sign_in(resource_name, resource)
    respond_with resource, :location => after_sign_in_path_for(resource)
  end

end
