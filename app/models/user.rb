class User < ApplicationRecord
    attr_reader :password
    validates :user_name, presence: true, uniqueness: true
    validates :password_digest, presence: true
    validates :password, length: { minimum: 6 }, allow_nil: true
    validates :session_token, presence: true, uniqueness: true
    
    after_initialize :ensure_session_token

    has_many :cats,
        class_name: :Cat,
        foreign_key: :user_id

    has_many :cat_rental_requests,
        class_name: :CatRentalRequest,
        foreign_key: :user_id

    def self.generate_session_token
        SecureRandom::urlsafe_base64
    end

    def reset_session_token!
        self.session_token = SecureRandom::urlsafe_base64
        self.save!
        self.session_token
    end

    def password=(password)
        self.password_digest = BCrypt::Password.create(password)
        @password = password
    end

    def ensure_session_token
        self.session_token ||= SecureRandom::urlsafe_base64
    end

    def is_password?(password)
        BCrypt::Password.new(self.password_digest).is_password?(password)
    end

    def self.find_by_credentials(user_name, password)
        user = User.find_by(user_name: user_name)
        return user if user && user.is_password?(password)
        nil
    end
end
