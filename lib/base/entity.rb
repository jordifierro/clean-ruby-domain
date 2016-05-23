require 'base/hashable'
require 'base/validatable'

module Base
  class Entity
    include Hashable
    include Validatable
  end
end
