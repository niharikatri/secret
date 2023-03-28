class AddIsTermsAndConditionsAcceptedToAccounts < ActiveRecord::Migration[6.0]
  def change
    add_column :accounts, :is_terms_and_conditions_accepted, :boolean, default: false
  end
end
