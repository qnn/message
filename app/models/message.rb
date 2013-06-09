class Message < ActiveRecord::Base
  attr_accessible :content, :name, :title
  validates_presence_of :name, :title, :content
  validates :name, :length => { :maximum => 60 }
  validates :title, :length => { :maximum => 200 }
  validates :content, :length => { :maximum => 20000 }
end
