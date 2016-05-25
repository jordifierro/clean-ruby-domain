require 'base/errors/token_error'

module User
  module UseCases
    class Logout
      def initialize(user_repo, auth_token)
        @user_repo = user_repo
        @auth_token = auth_token
      end

      def execute
        user = @user_repo.get(auth_token: @auth_token)
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
