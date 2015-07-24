class AddVerifiedToStory < ActiveRecord::Migration
  def change
    add_column :stories, :verified, :boolean
    add_index :stories, :verified
  end
end
