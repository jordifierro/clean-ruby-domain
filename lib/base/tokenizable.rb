module Base
  module Tokenizable
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def tokenizes(token)
        require 'securerandom'
        define_method("regenerate_#{token}!") do
          instance_variable_set("@#{token}", SecureRandom.urlsafe_base64(nil, false))
        end
      end
    end
  end
end
