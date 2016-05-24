module Base
  module Validatable
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def validate(&block)
        require 'dry-validation'
        const_set('DRY_VALIDATOR', Dry::Validation.Schema(&block))
        define_method('valid?') do
          valid = self.class.const_get('DRY_VALIDATOR').call(to_hash).success?
          raise ArgumentError unless valid
          return true
        end
      end
    end
  end
end
