class AddIndexOnArchiveUniquePublishedOnAndYear < ActiveRecord::Migration
  def change
    add_index :archives, [:published_on, :year], unique: true
  end
end
