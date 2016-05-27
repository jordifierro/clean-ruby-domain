require 'spec_helper'
require 'user/usecases/delete_account'

module User
  describe UseCases::DeleteAccount do
    let(:user_repo) { Object.new }

    it 'deletes the user from the user_repo and retursn true' do
      expect(user_repo).to receive(:delete).with(auth_token: 'TOKEN').and_return(true)

      expect(UseCases::DeleteAccount.new(user_repo, 'TOKEN').execute).to equal(true)
    end
  end
end
