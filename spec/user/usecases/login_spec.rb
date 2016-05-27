require 'spec_helper'
require 'user/usecases/login'
require 'base/errors'

module User
  describe UseCases::Login do
    let(:email) { 'email@mail.com' }
    let(:pass) { '12345678' }
    let(:user_repo) { Object.new }
    let(:user) { Object.new } 

    it 'gets the user, authenticate it and return it' do
      expect(user).to receive(:authenticate!).with(pass).and_return(true)
      expect(user_repo).to receive(:get).with(email: email).and_return(user)

      expect(UseCases::Login.new(user_repo, email, pass).execute).to equal(user)
    end
    
    it 'returns AuthenticationError if NotFoundError' do
      expect(user_repo).to receive(:get).with(email: email).and_raise(Base::Errors::NotFound)

      expect do
        UseCases::Login.new(user_repo, email, pass).execute
      end.to raise_error(Base::Errors::Authentication)
    end

    it 'returns AuthenticationError if authenticate returns false' do
      expect(user).to receive(:authenticate!).with(pass).and_raise(Base::Errors::Authentication)
      expect(user_repo).to receive(:get).with(email: email).and_return(user)

      expect do
        UseCases::Login.new(user_repo, email, pass).execute
      end.to raise_error(Base::Errors::Authentication)
    end
  end
end
