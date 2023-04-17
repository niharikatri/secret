class CreateBxBlockAdminContactUs < ActiveRecord::Migration[6.0]
  def change
    create_table :contact_us do |t|
      t.string :full_name
      t.string :email_address
      t.bigint :mobile_no
      t.text :message
    end
  end
end
