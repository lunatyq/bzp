class CreatePublications < ActiveRecord::Migration
  def change
    create_table :publications do |t|
      t.integer :biuletyn
      t.integer :pozycja
      t.date :data_publikacji
      t.string :nazwa
      t.string :ulica
      t.string :nr_domu
      t.string :nr_miesz
      t.string :miejscowosc
      t.string :kod_poczt
      t.string :wojewodztwo
      t.string :tel
      t.string :fax
      t.string :regon
      t.string :e_mail
      t.string :ogloszenie
      t.string :przedmiot_zam
      t.text :properties

      t.references :archive

      t.timestamps null: false
    end
  end
end
