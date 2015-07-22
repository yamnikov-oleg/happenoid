class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :short
      t.string :full

      t.timestamps null: false
    end
  end
end
