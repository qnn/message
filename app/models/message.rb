class Message < ActiveRecord::Base
  GENDERS = %w(mr ms)
  attr_accessible :content, :name, :title, :gender, :phone_number, :qq_number
  validates_presence_of :name, :title, :content, :gender, :phone_number
  validates :name, :length => { :maximum => 60 }
  validates :title, :length => { :maximum => 200 }
  validates :content, :length => { :maximum => 20000 }
  validates :qq_number, :length => { :maximum => 15 }
  validates :phone_number, :length => { :maximum => 30 }
  validates :gender, :inclusion => { :in => GENDERS }
  belongs_to :user, :foreign_key => "visible_to"
end

class String
  def real_gender_name
    I18n::t("helpers.label.message.gender_%s" % self)
  end
end
