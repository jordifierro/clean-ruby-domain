require 'spec_helper'
require 'user/usecases/logout_user'
require 'base/errors/not_found_error'
require 'base/errors/token_error'

module User
  describe UseCases::LogoutUser do
    let(:user_repo) { Object.new }
    let(:user) { Object.new }
    let(:request) { { user: { auth_token: 'TOKEN' } } }

    it 'gets the user, updates its auth_token and saves it' do
      expect(user).to receive(:regenerate_auth_token!).once
      expect(user).to receive(:valid?).and_return(true).once
      expect(user_repo).to receive(:find_by_auth_token).with('TOKEN').and_return(user)
      expect(user_repo).to receive(:save).and_return(true)

      UseCases::LogoutUser.new(user_repo, request).execute
    end

    it 'returns NotFound if user doesn\'t exists' do
      expect(user_repo).to receive(:find_by_auth_token).with('TOKEN').and_raise(Base::Errors::NotFoundError)

      expect do
        UseCases::LogoutUser.new(user_repo, request).execute
      end.to raise_error(Base::Errors::NotFoundError)
    end

    it 'repeats the regenerate_auth_token + save until successful save' do
      expect(user).to receive(:regenerate_auth_token!).exactly(3).times
      expect(user).to receive(:valid?).and_return(true).exactly(3).times
      expect(user_repo).to receive(:find_by_auth_token).with('TOKEN').and_return(user)
      expect(user_repo).to receive(:save).and_raise(Base::Errors::TokenError).twice
      expect(user_repo).to receive(:save).and_return(true)

      UseCases::LogoutUser.new(user_repo, request).execute
    end

    it 'returns true if success' do
      expect(user).to receive(:regenerate_auth_token!)
      expect(user).to receive(:valid?).and_return(true)
      expect(user_repo).to receive(:find_by_auth_token).with('TOKEN').and_return(user)
      expect(user_repo).to receive(:save).and_return(true)

      response = UseCases::LogoutUser.new(user_repo, request).execute
      expect(response).to be true
    end
  end
end
