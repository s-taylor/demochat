# == Schema Information
#
# Table name: tasks
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text
#  frequency   :integer
#  counter     :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Task < ActiveRecord::Base
  attr_accessible :name, :command, :frequency, :counter
end
