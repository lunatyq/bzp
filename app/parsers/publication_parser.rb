class PublicationParser
  vattr_initialize :xml

  def common_fields
    %w{
      biuletyn pozycja data_publikacji nazwa ulica nr_domu nr_miesz miejscowosc
      kod_poczt wojewodztwo tel fax regon e_mail ogloszenie przedmiot_zam
    }
  end

  def run
    data = extract_data
    root = data[data.keys.first]
    root.extract!(*common_fields).merge(properties: root)
  end

  def xml_to_hash(root)
    root.children.each_with_object({}) do |element, memo|
     if element.children.size == 1 && element.children.first.name == 'text'
      memo[element.name] = element.text
    else
      memo[element.name] = xml_to_hash(element)
    end
  end
end

  def extract_data
    xml_to_hash(Nokogiri::XML(xml))
  end
end
