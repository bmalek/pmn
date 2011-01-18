class User < ActiveRecord::Base

  validates_presence_of     :primarynumber
  validates_uniqueness_of   :primarynumber, :username
  #validates_acceptance_of   :terms_of_service, :on => :create
  #validates_confirmation_of :password, :email_address, :on => :create

  attr_accessor :password_confirmation
  validates_confirmation_of :password

  def validate
    errors.add_to_base("Missing password" ) if password_hash.blank?
  end

  def self.authenticate(username, password)
    user = self.find(:first, :conditions => [' username = ?' , username])
    if user
      expected_password = encrypted_password(password, user.password_salt)
      if user.password_hash != expected_password
        user = nil
      end
    end
    user
  end

  # 'password' is a virtual attribute

  #Now we need to write some code so that whenever a new plain-text password is
  #stored into a user object we automatically create a hashed version (which will
  #get stored in the database). We’ll do that by making the plain-text password a
  #virtual attribute of the model—it looks like an attribute to our application, but
  #it isn’t persisted into the database.

  def password
    @password
  end

  def password=(pwd)
    @password = pwd
    create_new_salt
    self.password_hash = User.encrypted_password(self.password, self.password_salt)
  end


  private

  def self.encrypted_password(password, salt)
    string_to_hash = password + "wibble" + salt # 'wibble' makes it harder to guess
    Digest::SHA1.hexdigest(string_to_hash)
  end

  def create_new_salt
    self.password_salt = self.object_id.to_s + rand.to_s
  end

end
