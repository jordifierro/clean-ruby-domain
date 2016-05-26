require 'base/errors'

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
        rescue Base::Errors::NotFound
          raise Base::Errors::Authentication
        end
        user.authenticate!(@password)
        user
      end
    end
  end
end
