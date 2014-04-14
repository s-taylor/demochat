# == Schema Information
#
# Table name: rooms
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#

class Room < ActiveRecord::Base
  attr_accessible :name, :description

  has_many :messages
  has_and_belongs_to_many :users
  has_many :votes

  validates :name, length: { minimum: 5 }
end
