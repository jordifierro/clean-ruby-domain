require 'spec_helper'
require 'user/usecases/login_user'
require 'user/user_entity'
require 'base/errors/not_found_error'

module User
  describe UseCases::LoginUser do
    let(:user_repo) { Object.new }
    let(:request) { { user: { email: 'e', password: '12345678' } } }
    let(:user) { UserEntity.new(request[:user]) }

    it 'returns user if exists and password matches' do
      expect(user_repo).to receive(:find_by_email).and_return(user)

      response = UseCases::LoginUser.new(user_repo, request).execute
      expect(response.key?(:user)).to be true
    end

    it 'raises ArgumentError if password doesn\'t matches' do
      user = UserEntity.new({ email: 'e', password: 'another_password' })
      expect(user_repo).to receive(:find_by_email).and_return(user)

      expect do
        UseCases::LoginUser.new(user_repo, request).execute
      end.to raise_error(ArgumentError)
    end

    it 'raises ArgumentError if user doesn\'t matches' do
      expect(user_repo).to receive(:find_by_email).and_raise(Base::Errors::NotFoundError)

      expect do
        UseCases::LoginUser.new(user_repo, request).execute
      end.to raise_error(ArgumentError)
    end
  end
end
