FactoryGirl.define do  factory :archive do
    year 1
published_on "2016-01-13"
extracted_at "2016-01-13 17:47:55"
imported_at "2016-01-13 17:47:55"
  end
  factory :publication do
    biuletyn 1
pozycja 1
data_publikacji "2016-01-13"
nazwa "MyString"
ulica "MyString"
nr_domu "MyString"
nr_miesz "MyString"
miejscowosc "MyString"
kod_poczt "MyString"
wojewodztwo "MyString"
tel "MyString"
fax "MyString"
regon "MyString"
e_mail "MyString"
ogloszenie "MyString"
przedmiot_zam "MyString"
  end

end
