require 'spec_helper'
require 'user/usecases/delete_account'

module User
  describe UseCases::DeleteAccount do
    let(:user_repo) { Object.new }

    it 'deletes the user from the user_repo' do
      expect(user_repo).to receive(:delete).with(auth_token: 'TOKEN').and_return(true)

      UseCases::DeleteAccount.new(user_repo, 'TOKEN').execute
    end

    it 'returns true if success' do
      expect(user_repo).to receive(:delete).with(auth_token: 'TOKEN').and_return(true)

      response = UseCases::DeleteAccount.new(user_repo, 'TOKEN').execute
      expect(response).to equal(true)
    end
  end
end
