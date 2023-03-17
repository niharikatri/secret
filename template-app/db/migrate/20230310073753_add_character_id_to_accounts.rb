class AddCharacterIdToAccounts < ActiveRecord::Migration[6.0]
  def change
    add_column :accounts, :character_id, :integer
    add_column :accounts, :voice_id, :integer
  end
end
