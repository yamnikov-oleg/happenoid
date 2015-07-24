class CreateAdminPasswords < ActiveRecord::Migration
  def change
    create_table :admin_passwords do |t|
      t.string :value

      t.timestamps null: false
    end
  end
end
