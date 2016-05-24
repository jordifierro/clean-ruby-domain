require 'base/errors/token_error'

module User
  module UseCases
    class CreateUser
      def initialize(user_repo, request)
        @user_repo = user_repo
        @request = request
      end

      def execute
        user = UserEntity.new(@request[:user])
        user.valid?
        begin
          created = @user_repo.save(user)
        rescue Base::Errors::TokenError
        end until created
        { user: user.to_hash }
      end
    end
  end
end
