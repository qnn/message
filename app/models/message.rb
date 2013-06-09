class Message < ActiveRecord::Base
  attr_accessible :content, :name, :title
  validates_presence_of :name, :title, :content
end
