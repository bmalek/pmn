class Coupon < ActiveRecord::Base
  belongs_to :user #, :polymorphic => true #, :foreign_key => "user_id"

  attr_accessible  :code

  #CLASS METHODS************************************************************

  def self.generate(user, number)
    user.coupons.each{|c| c.destroy}
    charset = %w{ 1 2 3 4 5 6 7 8 9 0 } #%w{A B C D E F G H J K L M N P Q R T V W X Y Z}
    number.to_i.times { 
      user.coupons << self.new(:code => (0...4).map{ Array(charset)[rand(charset.size)] }.join)
    }
    user.coupons 
  end

  #INSTANCE METHODS**********************************************************  

end
