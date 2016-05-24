require 'spec_helper'
require 'user/usecases/logout_user'
require 'base/errors/not_found_error'
require 'base/errors/token_error'

module User
  describe UseCases::LogoutUser do
    let(:token) { 'TOKEN' }
    let(:user_repo) { Object.new }
    let(:user_hash) { { email: 'email', password: '12345678', token: token } }

    it 'gets the user, updates its auth_token and saves it' do
      expect_any_instance_of(UserEntity).to receive(:regenerate_auth_token!).twice
      expect_any_instance_of(UserEntity).to receive(:valid?).and_return(true)
      expect(user_repo).to receive(:find).with(auth_token: token).and_return(user_hash)
      expect(user_repo).to receive(:save).and_return(true)

      UseCases::LogoutUser.new(user_repo, token).execute
    end

    it 'returns NotFound if user doesn\'t exists' do
      expect(user_repo).to receive(:find).with(auth_token: token).and_raise(Base::Errors::NotFoundError)

      expect do
        UseCases::LogoutUser.new(user_repo, token).execute
      end.to raise_error(Base::Errors::NotFoundError)
    end

    it 'repeats the regenerate_auth_token + save until successful save' do
      expect_any_instance_of(UserEntity).to receive(:regenerate_auth_token!).exactly(4).times
      expect_any_instance_of(UserEntity).to receive(:valid?).exactly(3).times.and_return(true)
      expect(user_repo).to receive(:find).with(auth_token: token).and_return(user_hash)
      expect(user_repo).to receive(:save).and_raise(Base::Errors::TokenError).twice
      expect(user_repo).to receive(:save).and_return(true)
      expect(user_repo).not_to receive(:save)

      UseCases::LogoutUser.new(user_repo, token).execute
    end

    it 'returns true if success' do
      expect_any_instance_of(UserEntity).to receive(:regenerate_auth_token!).twice
      expect_any_instance_of(UserEntity).to receive(:valid?).and_return(true)
      expect(user_repo).to receive(:find).with(auth_token: token).and_return(user_hash)
      expect(user_repo).to receive(:save).and_return(true)

      response = UseCases::LogoutUser.new(user_repo, token).execute
      expect(response).to be true
    end
  end
end
