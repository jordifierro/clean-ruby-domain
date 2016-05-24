require 'base/errors/not_found_error'

module User
  module UseCases
    class LoginUser
      def initialize(user_repo, request)
        @user_repo = user_repo
        @request = request
      end

      def execute
        begin
          user = @user_repo.find_by_email(@request[:user][:email])
        rescue Base::Errors::NotFoundError
          raise ArgumentError
        end
        raise ArgumentError unless user.authenticate?(@request[:user][:password])
        { user: user.to_hash } 
      end
    end
  end
end
