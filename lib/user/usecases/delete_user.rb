module User
  module UseCases
    class DeleteUser
      def initialize(user_repo, request)
        @user_repo = user_repo
        @request = request
      end

      def execute
        @user_repo.delete(@request[:user_id])
      end
    end
  end
end
