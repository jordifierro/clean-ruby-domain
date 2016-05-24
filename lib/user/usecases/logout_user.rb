require 'base/errors/token_error'

module User
  module UseCases
    class LogoutUser
      def initialize(user_repo, auth_token)
        @user_repo = user_repo
        @auth_token = auth_token
      end

      def execute
        user_hash = @user_repo.find(auth_token: @auth_token)
        user = UserEntity.new(user_hash)
        begin
          user.regenerate_auth_token!
          user.valid?
          updated = @user_repo.save(user.to_hash)
        rescue Base::Errors::TokenError
        end until updated
        true
      end
    end
  end
end
