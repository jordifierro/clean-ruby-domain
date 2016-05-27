module User
  module UseCases
    class ConfirmEmail
      def initialize(user_repo, user_hash)
        @user_repo = user_repo
        @user_hash = user_hash
      end

      def execute
        user = @user_repo.get(@user_hash)
        user.confirm!
        @user_repo.save(user)
      end
    end
  end
end
