require 'spec_helper'

describe Users::User do
  it 'initializes from hash'
  it 'returns attributes sanitized'

  it 'is not valid without email'
  it 'is not valid without password'
  it 'is not valid without auth_token'
  it 'is not valid without created_at'
  it 'is not valid without updated_at'

  it 'responds to email'
  it 'responds to auth_token'
  it 'responds to created_at'
  it 'responds to updated_at'
  it 'doesn\'t respond to password'	
  it 'doesn\'t respond to password_hash'	
  it 'doesn\'t respond to password_salt'	

  it 'responds to password=(new_password)'
  it 'sets a new password'
  it 'validates min password length'
  it 'validates max password length'

  it 'responds to authenticate(password)'
  it 'returns true if password matches'
  it 'returns false if wrong password'

  it 'responds to regenerate_auth_token'
  it 'regenerates auth_token'
end
