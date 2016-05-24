require 'base/errors/not_found_error'

module User
  module UseCases
    class GetCurrentUser
      def initialize(user_repo, request)
        @user_repo = user_repo
        @request = request
      end

      def execute
        { user: @user_repo.find_by_auth_token(@request[:user][:auth_token]) }
      end
    end
  end
end
