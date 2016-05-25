require 'spec_helper'
require 'user/usecases/register'
require 'user/user_entity'
require 'base/errors/token_error'

module User
  describe UseCases::Register do
    let(:user_repo) { Object.new }
    let(:user) { Object.new }
    let(:user_hash) { { email: 'e', password: '12345678' } }

    it 'calls user_repo create and returns created user' do
      expect(user_repo).to receive(:create).with(instance_of(UserEntity)).and_return(user)

      response = UseCases::Register.new(user_repo, user_hash).execute
      expect(response).to equal(user)
    end

    it 'repeats if TokenError' do
      expect(user_repo).to receive(:create).with(instance_of(UserEntity)).and_raise(Base::Errors::TokenError)
      expect(user_repo).to receive(:create).with(instance_of(UserEntity)).and_return(user)

      UseCases::Register.new(user_repo, user_hash).execute
    end
  end
end
