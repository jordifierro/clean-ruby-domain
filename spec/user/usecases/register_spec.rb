require 'spec_helper'
require 'user/usecases/register'
require 'user/entity'
require 'base/errors'

module User
  describe UseCases::Register do
    let(:user_repo) { Object.new }
    let(:user_mailer) { Object.new }
    let(:user) { Object.new }
    let(:user_hash) { { email: 'e', password: '12345678' } }
    let(:usecase) { UseCases::Register.new(user_repo, user_mailer, user_hash) }

    it 'creates, validates, saves, asks_conf and update user' do
      expect(usecase).to receive(:init_user_entity).and_return(user)
      expect(user).to receive(:valid?).and_return(true)
      expect(usecase).to receive(:save_token_aware).with(user).and_return(user)
      expect(usecase).to receive(:ask_email_confirmation).with(user).and_return(true)
      expect(usecase).to receive(:update_conf_asked_at).with(user).and_return(user)

      expect(usecase.execute).to equal(user)
    end

    describe 'init_user_entity method' do
      it 'calls User.new and returns created user' do
        expect(User::Entity).to receive(:new).with(user_hash).and_return(user)

        expect(usecase.send(:init_user_entity)).to equal(user)
      end
    end

    describe 'save_token_aware_method' do
      it 'regenerates tokens, saves user and returns saved' do
        expect(user).to receive(:regenerate_auth_token!)
        expect(user).to receive(:regenerate_conf_token!)
        expect(user_repo).to receive(:create).with(user).and_return(user)

        expect(usecase.send(:save_user_token_aware, user)).to equal(user)
      end

      it 'loops if UseToken error' do
        expect(user).to receive(:regenerate_auth_token!).twice
        expect(user).to receive(:regenerate_conf_token!).twice
        expect(user_repo).to receive(:create).with(user).and_raise(Base::Errors::UsedToken)
        expect(user_repo).to receive(:create).with(user).and_return(user)

        expect(usecase.send(:save_user_token_aware, user)).to equal(user)
      end
    end

    describe 'ask_email_confirmation method' do
      it 'calls user_mailer ask_email_conf method with user' do
        expect(user_mailer).to receive(:ask_email_conf).with(user).and_return(true)

        expect(usecase.send(:ask_email_confirmation, user)).to equal(true)
      end
    end

    describe 'update_conf_asked_at method' do
      it 'calls conf_asked!, saves user and returns it' do
        expect(user).to receive(:conf_asked!)
        expect(user_repo).to receive(:save).with(user).and_return(user)

        expect(usecase.send(:update_conf_asked_at, user)).to equal(user)
      end
    end
  end
end
