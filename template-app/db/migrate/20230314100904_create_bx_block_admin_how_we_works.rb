class CreateBxBlockAdminHowWeWorks < ActiveRecord::Migration[6.0]
  def change
    create_table :how_we_works do |t|
      t.text :description

      t.timestamps
    end
  end
end
