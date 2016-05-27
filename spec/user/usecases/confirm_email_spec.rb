require 'spec_helper'
require 'user/usecases/confirm_email'
require 'base/errors'

module User
  describe UseCases::ConfirmEmail do
    let(:user_repo) { Object.new }
    let(:user) { Object.new }
    let(:user_hash) { { email: 'email', conf_token: 'token' } } 

    it 'gets the user, calls conf_email!, saves user and returns it' do
      expect(user).to receive(:confirm!)
      expect(user_repo).to receive(:get).with(user_hash).and_return(user)
      expect(user_repo).to receive(:save).with(user).and_return(user)

      expect(UseCases::ConfirmEmail.new(user_repo, user_hash).execute).to equal(user)
    end
  end
end
