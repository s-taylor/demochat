# == Schema Information
#
# Table name: tasks
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text
#  frequency   :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Task < ActiveRecord::Base
  attr_accessible :name, :description, :frequency, :counter
end
