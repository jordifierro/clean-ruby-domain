require 'spec_helper'
require 'user/usecases/get_current_user'
require 'user/user_entity'
require 'base/errors/not_found_error'

module User
  describe UseCases::GetCurrentUser do
    let(:user_repo) { Object.new }
    let(:request) { { user: { auth_token: 'TOKEN' } } }
    let(:user) { UserEntity.new(request[:user]) }

    it 'returns user if exists with auth_token' do
      expect(user_repo).to receive(:find_by_auth_token).and_return(user)

      response = UseCases::GetCurrentUser.new(user_repo, request).execute
      expect(response.key?(:user)).to be true
    end

    it 'raises NotFoundError if auth_token doesn\'t matches' do
      expect(user_repo).to receive(:find_by_auth_token).and_raise(Base::Errors::NotFoundError)

      expect do
        UseCases::GetCurrentUser.new(user_repo, request).execute
      end.to raise_error(Base::Errors::NotFoundError)
    end
  end
end
