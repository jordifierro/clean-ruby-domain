require 'base/errors/not_found_error'

module User
  module UseCases
    class LoginUser
      def initialize(user_repo, email, password)
        @user_repo = user_repo
        @email = email
        @password = password
      end

      def execute
        begin
          user_hash = @user_repo.find_by_email(@email)
          user = UserEntity.new(user_hash)
        rescue Base::Errors::NotFoundError
          raise ArgumentError
        end
        raise ArgumentError unless user.authenticate?(@password)
        { user: user.to_hash } 
      end
    end
  end
end
