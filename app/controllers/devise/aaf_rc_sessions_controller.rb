class Devise::AafRcSessionsController < Devise::SessionsController
  unloadable
  prepend_before_filter :require_no_authentication, :only => [ :aaf_new, :aaf_create ]
  def aaf_new
    config = YAML.load(ERB.new(File.read(::Devise.aaf_rc_config || "#{Rails.root}/config/aaf_rc.yml")).result)[Rails.env]

    redirect_to config['aaf_rc_login_url']
  end

  def aaf_create
    #the authentication is taken care of by the strategy
  end

  def destroy
    session.delete(:attributes)
    session.delete(:jwt)
    super
  end

end
