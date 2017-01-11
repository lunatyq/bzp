class ArchivesAddVersionIndex < ActiveRecord::Migration
  def change
    remove_index :archives, name: :index_archives_on_published_on_and_year
    add_index :archives, [:published_on, :version], unique: true
  end
end
