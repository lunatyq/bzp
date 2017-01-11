class ArchiveAddVersion < ActiveRecord::Migration
  def change
    add_column :archives, :version, :string
  end
end
