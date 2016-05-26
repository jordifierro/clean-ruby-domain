require 'spec_helper'
require 'user/entity'
require 'base/errors'

describe User::Entity do
  let(:user) { User::Entity.new(email: 'email', password: '12345678') }

  it { expect(user).to be_valid }

  it 'returns corresponding attributes' do
    attrs = user.to_hash
    expect(attrs.key?(:id)).to be true
    expect(attrs.key?(:email)).to be true
    expect(attrs.key?(:password)).to be false
    expect(attrs.key?(:password_hash)).to be true
    expect(attrs.key?(:password_salt)).to be true
    expect(attrs.key?(:auth_token)).to be true
    expect(attrs.key?(:created_at)).to be true
    expect(attrs.key?(:updated_at)).to be true
  end

  describe 'defines public methods' do
    it { expect(user.respond_to?(:id)).to be true }
    it { expect(user.respond_to?(:email)).to be true }
    it { expect(user.respond_to?(:auth_token)).to be true }
    it { expect(user.respond_to?(:created_at)).to be true }
    it { expect(user.respond_to?(:updated_at)).to be true }
    it { expect(user.respond_to?(:password)).to be false }
    it { expect(user.respond_to?(:password_hash)).to be true }
    it { expect(user.respond_to?(:password_salt)).to be true }
    it { expect(user.respond_to?(:authenticate!)).to be true }
    it { expect(user.respond_to?(:regenerate_auth_token!)).to be true }
    it { expect(user.respond_to?(:password=)).to be true }
  end

  describe 'validates attributes' do
    it 'is not valid without email' do
      user.instance_variable_set('@email', nil)
      expect { user.valid? }.to raise_error(Base::Errors::BadParams)
    end

    it 'email has to be a String' do
      user.instance_variable_set('@email', 1)
      expect { user.valid? }.to raise_error(Base::Errors::BadParams)

      user.instance_variable_set('@email', 'email')
      expect(user.valid?).to be true
    end

    it 'is not valid without password_hash' do
      user.instance_variable_set('@password_hash', nil)
      expect { user.valid? }.to raise_error(Base::Errors::BadParams)
    end

    it 'password_hash has to be a String' do
      user.instance_variable_set('@password_hash', 1)
      expect { user.valid? }.to raise_error(Base::Errors::BadParams)

      user.instance_variable_set('@password_hash', 'HASH')
      expect(user.valid?).to be true
    end

    it 'is not valid without password_salt' do
      user.instance_variable_set('@password_salt', nil)
      expect { user.valid? }.to raise_error(Base::Errors::BadParams)
    end

    it 'password_salt has to be a String' do
      user.instance_variable_set('@password_salt', 1)
      expect { user.valid? }.to raise_error(Base::Errors::BadParams)

      user.instance_variable_set('@password_salt', 'SALT')
      expect(user.valid?).to be true
    end

    it 'is not valid without auth_token' do
      user.instance_variable_set('@auth_token', nil)
      expect { user.valid? }.to raise_error(Base::Errors::BadParams)
    end

    it 'auth_token has to be a String' do
      user.instance_variable_set('@auth_token', 1)
      expect { user.valid? }.to raise_error(Base::Errors::BadParams)

      user.instance_variable_set('@auth_token', 'TOKEN')
      expect(user.valid?).to be true
    end

    it 'is not valid without created_at' do
      user.instance_variable_set('@created_at', nil)
      expect { user.valid? }.to raise_error(Base::Errors::BadParams)
    end

    it 'created_at has to be a String' do
      user.instance_variable_set('@created_at', Time.now)
      expect { user.valid? }.to raise_error(Base::Errors::BadParams)

      user.instance_variable_set('@created_at', '12/08/2009')
      expect(user.valid?).to be true
    end

    it 'is not valid without updated_at' do
      user.instance_variable_set('@updated_at', nil)
      expect { user.valid? }.to raise_error(Base::Errors::BadParams)
    end

    it 'updated_at has to be a String' do
      user.instance_variable_set('@updated_at', Time.now)
      expect { user.valid? }.to raise_error(Base::Errors::BadParams)

      user.instance_variable_set('@updated_at', '12/03/2003')
      expect(user.valid?).to be true
    end
  end

  it 'sanitizes attributes' do
    params = { email: 'email', password: 'password', evil_attr: 'danger' }
    user = User::Entity.new(params)
    expect(user.instance_variable_defined?('@evil_attr')).to be false
    expect(user.respond_to?(:evil_attr)).to be false
    expect(user.to_hash.key?(:evil_attr)).to be false
  end

  describe 'authenticate!(password) method' do
    it { expect(user.authenticate!('12345678')).to be true }
    it { expect { user.authenticate!('wrong_pass') }.to raise_error(Base::Errors::Authentication) }
  end

  describe 'password=(new_password) method' do
    it 'sets a new password' do
      user.password = 'another_password'
      expect(user.authenticate!('another_password')).to be true
    end

    it 'validates min password length == 8' do
      expect { user.password = 'short' }.to raise_error(Base::Errors::BadParams)
      expect(user.authenticate!('12345678')).to be true
    end

    it 'validates max password length == 72' do
      long_pass = ''
      73.times { long_pass << 'x' }
      expect { user.password = long_pass }.to raise_error(Base::Errors::BadParams)
      expect(user.authenticate!('12345678')).to be true

      user.password = long_pass[0..71]
      expect(user.authenticate!(long_pass[0..71])).to be true
    end
  end

  describe 'regenerate_auth_token! method' do
    it 'regenerates auth_token' do
      old_token = user.auth_token
      user.regenerate_auth_token!
      expect(user.auth_token).not_to equal(old_token)
    end

    it 'user SecureRandom' do
      user
      expect(SecureRandom).to receive(:urlsafe_base64).with(nil, false)
      user.regenerate_auth_token!
    end
  end
end
