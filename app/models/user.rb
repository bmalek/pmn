class User < ActiveRecord::Base

  # For security pruposes, just to say that what values can be accessed via params[:*]
  #attr_accessible :username, :password, :primarynumber, :password_confirmation, :challenge_code

  #before_validation :is_authenticated?

  #VALIDATIONS***************************************************************
  validates_presence_of     :primarynumber, :username, :password

  validates_uniqueness_of   :primarynumber, :username
  #validates_acceptance_of  :terms_of_service, :on => :create

  validates_format_of       :username, :with => /^([a-z0-9_]{4,16})$/i,
    :message => "must be 4 to 16 letters, numbers or underscores and have no spaces"

  validates_format_of       :password, :with => /^([\x20-\x7E]){4,16}$/,
    :message => "must be 4 to 16 characters"

  validates_confirmation_of :password

  attr_accessor :password_confirmation
  
  #FILTERS******************************************************************
  before_save :scrub_username
  after_save :flush_passwords


  #CLASS METHODS************************************************************

  def self.find_by_username_and_password(username, password)
    user = self.find_by_username(username)
    if user and user.password_hash == encrypted_password(password, user.password_salt)
      return user
    end
  end

  #INSTANCE METHODS*********************************************************
  def generate_challenge_code    
    charset = %w{A B C D E F G H J K L M N P Q R T V W X Y Z}
    (0...4).map{ charset.to_a[rand(charset.size)] }.join
  end

  def verified_response_code?(cc)
    self.response_code.upcase! == cc
  end


  #VIRTUAL ATTRIBUTES********************************************************

  # custom setter method (input to database) needed fot the controller
  def response_code=(rc)
    @response_code = rc
  end

  #custom getter method (output from database) needed for the view
  def response_code
    @response_code
  end

  # 'password' is a virtual attribute

  #Now we need to write some code so that whenever a new plain-text password is
  #stored into a user object we automatically create a hashed version (which will
  #get stored in the database). We’ll do that by making the plain-text password a
  #virtual attribute of the model—it looks like an attribute to our application, but
  #it isn’t persisted into the database.

  #custom getter method (output from database)
  def password
    @password
  end

  # custom setter method (input to database)
  def password=(pwd)
    @password = pwd
    create_new_salt
    self.password_hash = User.encrypted_password(self.password, self.password_salt)
  end


  # PRIVATE METHODS*********************************************************
  private

  def self.encrypted_password(password, salt)
    string_to_hash = password + "wibble" + salt # 'wibble' makes it harder to guess
    Digest::SHA1.hexdigest(string_to_hash)
  end

  def create_new_salt
    self.password_salt = self.object_id.to_s + rand.to_s
  end

  def scrub_username
    self.username.downcase!
  end

  def flush_passwords
    @password = @password_confirmation = nil
  end

end
