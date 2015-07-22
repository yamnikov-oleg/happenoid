class CreateStories < ActiveRecord::Migration
  def change
    create_table :stories do |t|
      t.string :title
      t.integer :rating
      t.text :text

      t.timestamps null: false
    end
  end
end
