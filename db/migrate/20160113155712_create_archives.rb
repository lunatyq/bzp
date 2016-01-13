class CreateArchives < ActiveRecord::Migration
  def change
    create_table :archives do |t|
      t.integer :year
      t.date :published_on
      t.datetime :extracted_at
      t.datetime :imported_at

      t.timestamps null: false
    end
  end
end
