module User
  module UseCases
    class DeleteUser
      def initialize(user_repo, auth_token)
        @user_repo = user_repo
        @auth_token = auth_token
      end

      def execute
        @user_repo.delete(auth_token: @auth_token)
      end
    end
  end
end
