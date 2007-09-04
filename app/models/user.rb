require 'digest/sha1'
class User < ActiveRecord::Base
  belongs_to :customer
  has_many :carts
  # Virtual attribute for the unencrypted password
  attr_accessor :password

  validates_presence_of     :login, :email
  validates_presence_of     :password,                   :if => :password_required?
  validates_presence_of     :password_confirmation,      :if => :password_required?
  validates_length_of       :password, :within => 4..40, :if => :password_required?
  validates_confirmation_of :password,                   :if => :password_required?
  validates_length_of       :login,    :within => 3..40
  validates_length_of       :email,    :within => 3..100
  validates_uniqueness_of   :login, :email, :case_sensitive => false
  before_save :encrypt_password

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
    u = find_by_login(login) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("#{salt}#{password}")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    @salt = get_salt
    part = Digest::SHA1.hexdigest("#{@salt}#{password}")
    encrypted_password = "#{@salt}#{part}"
    # [php] 
    #   $salt = substr($password,0,10);
    #   $password_hash = salt.sha1($salt.$password);
    # [/php]
    
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    remember_me_for 2.weeks
  end

  def remember_me_for(time)
    remember_me_until time.from_now.utc
  end

  def remember_me_until(time)
    self.remember_token_expires_at = time
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end

  def get_salt
    self.crypted_password? ? salt = crypted_password.slice(0,10) : salt = 'ABCDEFGHIY'
    return salt
  end

  protected
    # before filter 
    # overriden to use existing salt generation from fastmount version 1, 
    # which was 
    # [php] 
    #   $salt = substr($password,0,10);
    #   $password_hash = salt.sha1($salt.$password);
    # [/php]
    #

    
    
    def encrypt_password
      return if password.blank?
      get_salt
      pass_part = self.encrypt(password)
      self.crypted_password = "#{pass_part}"
    end
    
    def password_required?
      crypted_password.blank? || !password.blank?
    end
end
