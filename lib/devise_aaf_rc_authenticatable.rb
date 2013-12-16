# encoding: utf-8
require 'devise'

require 'devise_aaf_rc_authenticatable/exception'
require 'devise_aaf_rc_authenticatable/logger'
require 'devise_aaf_rc_authenticatable/schema'
require 'devise_aaf_rc_authenticatable/routes'
require 'devise_aaf_rc_authenticatable/railtie'

begin
  Rails::Engine
rescue
else
  module DeviseAafRcAuthenticatable
    class Engine < Rails::Engine
    end
  end
end

# Get aaf_rc information from config/aaf_rc.yml now
module Devise
  # Allow logging
  mattr_accessor :aaf_rc_logger
  @@aaf_rc_logger = true
  
  # Add valid users to database
  mattr_accessor :aaf_rc_create_user
  @@aaf_rc_create_user = false
  
  mattr_accessor :aaf_rc_config
  @@aaf_rc_config = "/Users/jake/Projects/snap-deploy/config/aaf_rc.yml"
  
end

# Add aaf_rc_authenticatable strategy to defaults.
#
Devise.add_module(:aaf_rc_authenticatable,
                  :route => :aaf_rc_authenticatable,
                  :strategy   => true,
                  :controller => :aaf_rc_sessions,
                  :model  => 'devise_aaf_rc_authenticatable/model')
