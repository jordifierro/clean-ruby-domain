require 'base/errors/not_found_error'

module User
  module UseCases
    class GetCurrentUser
      def initialize(user_repo, auth_token)
        @user_repo = user_repo
        @auth_token = auth_token
      end

      def execute
        { user: @user_repo.find(auth_token: @auth_token) }
      end
    end
  end
end
