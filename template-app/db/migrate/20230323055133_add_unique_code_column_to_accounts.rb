class AddUniqueCodeColumnToAccounts < ActiveRecord::Migration[6.0]
  def change
    add_column :accounts, :unique_code, :string
  end
end
