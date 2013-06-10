class AddPhoneNumberToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :phone_number, :string
    add_column :messages, :qq_number, :string
    add_column :messages, :gender, :string
    add_column :messages, :visible_to, :integer
  end
end
