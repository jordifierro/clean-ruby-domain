require 'base/hashable'
require 'base/validatable'
require 'base/tokenizable'

module Base
  class Entity
    include Hashable
    include Validatable
    include Tokenizable
  end
end
