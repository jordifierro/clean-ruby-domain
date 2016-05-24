require 'spec_helper'
require 'user/usecases/create_user'
require 'user/user_entity'
require 'base/errors/token_error'

module User
  describe UseCases::CreateUser do
    let(:user_repo) { Object.new }
    let(:user_hash) { { email: 'e', password: '12345678' } }

    it 'returns correct response with the user hash' do
      expect(user_repo).to receive(:save).and_return(true)

      response = UseCases::CreateUser.new(user_repo, user_hash).execute
      expect(response.key?(:user)).to be true
    end

    it 'saves the user in the user_repo' do
      expect(user_repo).to receive(:save).and_return(true)

      UseCases::CreateUser.new(user_repo, user_hash).execute
    end

    it 'repeats the save while TokenError' do
      expect(user_repo).to receive(:save).and_raise(Base::Errors::TokenError).twice
      expect(user_repo).to receive(:save).and_return(true)
      expect(user_repo).to_not receive(:save)

      UseCases::CreateUser.new(user_repo, user_hash).execute
    end
  end
end
