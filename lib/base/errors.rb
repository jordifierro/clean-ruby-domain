module Base
  module Errors
    class NotFound        < StandardError; end
    class UsedToken       < StandardError; end
    class Authentication  < StandardError; end
  end
end
