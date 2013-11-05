module DeviseAafRcAuthenticatable

  class Logger    
    def self.send(message, logger = Rails.logger)
      if ::Devise.aaf_rc_logger
        logger.add 0, "  \e[36mAAF Rapid Connect:\e[0m #{message}"
      end
    end
  end

end
