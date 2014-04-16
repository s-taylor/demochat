# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  username               :string(255)
#  image                  :text
#  last_active            :datetime
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :username, :password, :password_confirmation

  has_many :messages
  has_and_belongs_to_many :rooms
  has_many :responses

  #validation for username
  #username must be populated, a minimum of 5 characters, maximum of 16 characters and is unique
	validates :username, :presence => true, length: { minimum: 5, maximum: 20 }, :uniqueness => { case_sensitive: false }, format: { with: /\A[a-zA-Z0-9]+\Z/, message: "only allows alphanumeric characters" } 
 
  #validation for email at login  
	validates :email, :presence => true, :uniqueness => true, :length => { :minimum => 2 }

  def self.check_inactive
    #log message that cleanup is happening
    puts "performing inactive users cleanup"
    #find inactive users (users who have not pinged the server within the last 60 seconds)
    inactive_users = self.where('last_active < ?',(Time.now - 60))
    # inactive_users = User.where('last_active < ?',(Time.now - 60))

    #set last active to nil and destroy User => Room relationship
    inactive_users.each do |user|
      #clear the last active timestamp so user not picked up on next check
      user.last_active = nil
      #remove the rooms attached to the user
      user.rooms = [] 
      #save the user
      user.save
    end

    #return the inactive users found
    inactive_users
  end
  	  		
end
