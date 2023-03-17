class AddFieldsToAccounts < ActiveRecord::Migration[6.0]
  def change
    add_column :accounts, :date_of_birth, :date
    add_column :accounts, :gender, :integer
    add_column :accounts, :autoplay_setting, :boolean, default: true
    add_column :accounts, :reply_audio_setting, :boolean, default: true
  end
end
