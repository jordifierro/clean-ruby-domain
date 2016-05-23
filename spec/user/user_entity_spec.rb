require 'spec_helper'
require 'user/user_entity'

describe User::UserEntity do
  let(:user) { User::UserEntity.new({ email: 'email', password: '12345678' }) }

  it { expect(user).to be_valid }

  it 'returns corresponding attributes' do
    attrs = user.attributes
    expect(attrs.key?(:email)).to be_true
    expect(attrs.key?(:password)).to be_false
    expect(attrs.key?(:password_hash)).to be_false
    expect(attrs.key?(:password_salt)).to be_false
    expect(attrs.key?(:auth_token)).to be_true
    expect(attrs.key?(:created_at)).to be_true
    expect(attrs.key?(:updated_at)).to be_true
  end

  describe 'defines public methods' do
    it { expect(user.respond_to?(:email)).to be_true }
    it { expect(user.respond_to?(:auth_token)).to be_true }
    it { expect(user.respond_to?(:auth_token)).to be_true }
    it { expect(user.respond_to?(:updated_at)).to be_true }
    it { expect(user.respond_to?(:password)).to be_true }
    it { expect(user.respond_to?(:password_hash)).to be_true }
    it { expect(user.respond_to?(:password_salt)).to be_true }
    it { expect(user.respond_to?(:authenticate?)).to be_true }
    it { expect(user.respond_to?(:regenerate_auth_token!)).to be_true }
    it { expect(user.respond_to?(:password=)).to be_true }
  end

  describe 'validates attributes' do 
    it 'is not valid without email' do
      user.email = nil
      expect(user.valid?).to be_false
    end

    it 'is not valid without password_hash' do
      user.instance_variable_set('@password_hash', nil)
      expect(user.valid?).to be_false
    end

    it 'is not valid without password_salt' do
      user.instance_variable_set('@password_salt', nil)
      expect(user.valid?).to be_false
    end

    it 'is not valid without auth_token' do
      user.instance_variable_set('@auth_token', nil)
      expect(user.valid?).to be_false
    end

    it 'is not valid without created_at' do
      user.instance_variable_set('@created_at', nil)
      expect(user.valid?).to be_false
    end

    it 'is not valid without updated_at' do
      user.instance_variable_set('@updated_at', nil)
      expect(user.valid?).to be_false
    end
  end
  
  it 'sanitizes attributes' do
    params = { email: 'email', password: 'password', evil_attr: 'danger' }
    user = User::UserEntity.new(params)
    expect(user.instance_variable_defined?('@evil_attr')).to be_false
    expect(user.attributes.key?(:evil_attr)).to be_false
  end

  describe 'authenticate?(password) method' do
    it { expect(user.authenticate?('12345678')).to be_true }
    it { expect(user.authenticate?('wrong_pass')).to be_true }
  end

  describe 'password=(new_password) method' do
    it 'sets a new password' do
      user.password = 'another_password'
      expect(user.authenticate?('another_password')).to be_true
    end

    it 'validates min password length == 8' do
      user.password = 'short'
      expect(user.authenticate?('short')).to be_true
      expect(user.authenticate?('12345678')).to be_true
    end

    it 'validates max password length == 72' do
      long_pass = ""
      73.times { new_pass << 'x' }
      user.password = long_pass
      expect(user.authenticate?(long_pass)).to be_false
      expect(user.authenticate?('12345678')).to be_false

      user.password = long_pass[0..71]
      expect(user.authenticate?(long_pass[0..71])).to be_true
    end
  end

  describe 'regenerate_auth_token! method' do
    it 'regenerates auth_token' do
      old_token = user.auth_token
      user.regenerate_auth_token!
      expect(user.auth_token).not_to equal(old_token)
    end
  end
end
