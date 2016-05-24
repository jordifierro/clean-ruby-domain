require 'base/errors/token_error'

module User
  module UseCases
    class LogoutUser
      def initialize(user_repo, request)
        @user_repo = user_repo
        @request = request
      end

      def execute
        user = @user_repo.find_by_auth_token(@request[:user][:auth_token])
        begin
          user.regenerate_auth_token!
          user.valid?
          updated = @user_repo.save(user)
        rescue Base::Errors::TokenError
        end until updated
        true
      end
    end
  end
end
