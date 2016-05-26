module Base
  module Validatable
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def validates(name=nil, &block)
        require 'dry-validation'
        scope = ''
        scope = "#{name.to_s}_" if !name.nil?
        const_set("#{scope.upcase}DRY_VALIDATOR", Dry::Validation.Schema(&block))
        define_method("#{scope}valid?") do |hash=nil|
          target = hash || to_hash
          valid = self.class.const_get("#{scope.upcase}DRY_VALIDATOR").call(target).success?
          raise Base::Errors::BadParams unless valid
          return true
        end
      end
    end
  end
end
