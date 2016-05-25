require 'spec_helper'
require 'user/usecases/logout'
require 'base/errors/not_found_error'
require 'base/errors/token_error'

module User
  describe UseCases::Logout do
    let(:token) { 'TOKEN' }
    let(:user_repo) { Object.new }
    let(:user) { Object.new }
    let(:user_hash) { { email: 'email', password: '12345678', token: token } }

    it 'gets the user, regenerates token, validates, saves it and return true' do
      expect(user).to receive(:regenerate_auth_token!)
      expect(user).to receive(:valid?)
      expect(user_repo).to receive(:get).with(auth_token: token).and_return(user)
      expect(user_repo).to receive(:save).with(user).and_return(true)

      response = UseCases::Logout.new(user_repo, token).execute
      expect(response).to equal(true)
    end

    it 'repeats if TokenError' do
      expect(user).to receive(:regenerate_auth_token!).twice
      expect(user).to receive(:valid?).twice
      expect(user_repo).to receive(:get).with(auth_token: token).and_return(user)
      expect(user_repo).to receive(:save).with(user).and_raise(Base::Errors::TokenError)
      expect(user_repo).to receive(:save).with(user).and_return(true)

      UseCases::Logout.new(user_repo, token).execute
    end
  end
end
