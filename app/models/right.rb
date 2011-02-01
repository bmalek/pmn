class Right < ActiveRecord::Base
  has_and_belongs_to_many :roles
  validates_presence_of :controller, :action, :name
  validates_uniqueness_of :name
end
