class AddPublicationIndexOnPublishedOnAndPosition < ActiveRecord::Migration
  def change
    add_index :publications, [:data_publikacji, :pozycja], unique: true
  end
end
