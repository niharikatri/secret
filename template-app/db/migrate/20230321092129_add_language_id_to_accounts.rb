class AddLanguageIdToAccounts < ActiveRecord::Migration[6.0]
  def change
    add_column :accounts, :language_id, :integer
  end
end
