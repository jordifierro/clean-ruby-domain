module Base
  module Hashable
    def to_hash
      hash = {}
      instance_variables.each do |var|
        key = var.to_s.delete('@').to_sym
        hash[key] = instance_variable_get(var) if respond_to?(key)
      end
      hash
    end
  end
end
