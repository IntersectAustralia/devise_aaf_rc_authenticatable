class Devise::AafRcSessionsController < Devise::SessionsController
  unloadable
  
  def aaf_new
    #the authentication is taken care of by the strategy
  end

  def destroy
    session.delete(:attributes)
    session.delete(:jwt)
    super
  end

end
