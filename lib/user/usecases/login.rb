require 'base/errors/not_found_error'

module User
  module UseCases
    class Login
      def initialize(user_repo, email, password)
        @user_repo = user_repo
        @email = email
        @password = password
      end

      def execute
        begin
          user = @user_repo.get(email: @email)
        rescue Base::Errors::NotFoundError
          raise ArgumentError
        end
        raise ArgumentError unless user.authenticate(@password)
        user
      end
    end
  end
end
