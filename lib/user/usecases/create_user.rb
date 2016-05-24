require 'base/errors/token_error'

module User
  module UseCases
    class CreateUser
      def initialize(user_repo, user_hash)
        @user_repo = user_repo
        @user_hash = user_hash
      end

      def execute
        user = UserEntity.new(@user_hash)
        user.valid?
        begin
          user.regenerate_auth_token!
          created = @user_repo.save(user.to_hash)
        rescue Base::Errors::TokenError
        end until created
        { user: user.to_hash }
      end
    end
  end
end
