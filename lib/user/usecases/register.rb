require 'base/errors'

module User
  module UseCases
    class Register
      def initialize(user_repo, user_hash)
        @user_repo = user_repo
        @user_hash = user_hash
      end

      def execute
        user = Entity.new(@user_hash)
        begin
          user.regenerate_auth_token!
          user.valid?
          created = @user_repo.create(user)
        rescue Base::Errors::UsedToken
        end until created
        created
      end
    end
  end
end
