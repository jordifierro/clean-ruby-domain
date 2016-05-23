require 'bcrypt'
require 'dry-validation'

module User
  class UserEntity
    attr_reader :email
    attr_reader :auth_token
    attr_reader :created_at
    attr_reader :updated_at
    attr_reader :password_salt
    attr_reader :password_hash

    def initialize(hash)
      @email = hash[:email]

      @password_hash = hash[:password_hash]
      @password_salt = hash[:password_salt]
      send(:password=, hash[:password]) if hash.key?(:password)

      if hash[:auth_token]
        @auth_token = hash[:auth_token]
      else
        regenerate_auth_token!
      end

      @created_at = hash[:created_at] || Time.now.to_s
      @updated_at = hash[:updated_at] || Time.now.to_s
    end

    def valid?
      validator = Dry::Validation.Schema do
        key(:email).required(:str?)
        key(:password_hash).required(:str?)
        key(:password_salt).required(:str?)
        key(:auth_token).required(:str?)
        key(:created_at).required(:str?)
        key(:updated_at).required(:str?)
      end      
      return validator.call(to_hash).success?
    end

    def regenerate_auth_token!
      @auth_token = SecureRandom.urlsafe_base64(nil, false)
    end

    def password=(new_password)
      raise ArgumentError if new_password.length < 8 || new_password.length > 72
      @password_salt = BCrypt::Engine.generate_salt
      @password_hash = BCrypt::Engine.hash_secret(new_password, @password_salt)
    end

    def authenticate?(password)
      return @password_hash == BCrypt::Engine.hash_secret(password, @password_salt)
    end 

    def to_hash
        hash = {}
        instance_variables.each do |var|
          key = var.to_s.delete('@').to_sym
          hash[key] = instance_variable_get(var) if respond_to?(key)
        end
        hash
    end
  end
end
