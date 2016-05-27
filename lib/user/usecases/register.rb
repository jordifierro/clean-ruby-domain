require 'base/errors'

module User
  module UseCases
    class Register
      def initialize(user_repo, user_mailer, user_hash)
        @user_repo = user_repo
        @user_hash = user_hash
        @user_mailer = user_mailer
      end

      def execute
        user = init_user_entity
        user.valid?
        user = save_token_aware(user)
        ask_email_confirmation(user)
        user = update_conf_asked_at(user)
        user
      end

      private

      def init_user_entity
        Entity.new(@user_hash)
      end

      def save_user_token_aware(user)
        begin
          user.regenerate_auth_token!
          user.regenerate_conf_token!
          created = @user_repo.create(user)
        rescue Base::Errors::UsedToken
        end until created
        created
      end

      def ask_email_confirmation(user)
        @user_mailer.ask_email_conf(user)
      end

      def update_conf_asked_at(user)
        user.conf_asked!
        @user_repo.save(user)
      end
    end
  end
end
