class CreateBxBlockAdminAboutUs < ActiveRecord::Migration[6.0]
  def change
    create_table :about_us do |t|
      t.text :description

      t.timestamps
    end
  end
end
