require 'spec_helper'
require 'user/usecases/login_user'
require 'user/user_entity'
require 'base/errors/not_found_error'

module User
  describe UseCases::LoginUser do
    let(:email) { 'email@mail.com' }
    let(:pass) { '12345678' }
    let(:user_repo) { Object.new }
    let(:user_hash) { { email: email, password: pass } }

    it 'returns user if exists and password matches' do
      expect(user_repo).to receive(:find_by_email).and_return(user_hash)

      response = UseCases::LoginUser.new(user_repo, email, pass).execute
      expect(response.key?(:user)).to be true
    end

    it 'raises ArgumentError if password doesn\'t matches' do
      user_hash = { email: email, password: '1234' }
      expect(user_repo).to receive(:find_by_email).and_return(user_hash)

      expect do
        UseCases::LoginUser.new(user_repo, email, pass).execute
      end.to raise_error(ArgumentError)
    end

    it 'raises ArgumentError if user doesn\'t matches' do
      expect(user_repo).to receive(:find_by_email).and_raise(Base::Errors::NotFoundError)

      expect do
        UseCases::LoginUser.new(user_repo, email, pass).execute
      end.to raise_error(ArgumentError)
    end
  end
end
