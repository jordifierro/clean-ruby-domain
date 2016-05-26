require 'bcrypt'
require 'base/entity'
require 'base/errors'
require 'securerandom'

module User
  class Entity < Base::Entity
    attr_reader :id
    attr_reader :email
    attr_reader :password_salt
    attr_reader :password_hash
    attr_reader :auth_token
    attr_reader :created_at
    attr_reader :updated_at

    validates do
      key(:email).required(:str?)
      key(:password_hash).required(:str?)
      key(:password_salt).required(:str?)
      key(:auth_token).required(:str?)
      key(:created_at).required(:str?)
      key(:updated_at).required(:str?)
    end

    validates :password do
      key(:password) { str? & size?(8..72) }
    end

    tokenizes :auth_token

    def initialize(hash)
      @id = hash[:id]
      @email = hash[:email]

      @password_hash = hash[:password_hash]
      @password_salt = hash[:password_salt]
      send(:password=, hash[:password]) if hash.key?(:password)

      token = hash[:auth_token]
      token ? @auth_token = token : regenerate_auth_token!

      @created_at = hash[:created_at] || Time.now.to_s
      @updated_at = hash[:updated_at] || Time.now.to_s
    end

    def password=(new_pass)
      password_valid?(password: new_pass)
      @password_salt = BCrypt::Engine.generate_salt
      @password_hash = BCrypt::Engine.hash_secret(new_pass, @password_salt)
    end

    def authenticate!(password)
      return true if @password_hash == BCrypt::Engine.hash_secret(password, @password_salt)
      raise Base::Errors::Authentication
    end
  end
end
