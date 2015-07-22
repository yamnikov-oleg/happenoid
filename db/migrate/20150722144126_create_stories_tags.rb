class CreateStoriesTags < ActiveRecord::Migration
  def change
    create_table :stories_tags do |t|
      t.references :story, index: true, foreign_key: true
      t.references :tag, index: true, foreign_key: true
    end
  end
end
