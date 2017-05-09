data = []
Publication.where("ogloszenie LIKE '%udzieleniu zamówienia'").find_each do |publication|
  procurement = Procurement.new(publication.properties)

  parts = procurement.parts.reject(&:cancelled?)

  unless parts.any?
    next
  end

  data << OpenStruct.new(
    data: publication.data_publikacji,
    tryb: procurement.tryb,
    ofert: parts.map(&:offers).reduce(:+),
    ofert_msp: parts.map(&:smb_offers).reduce(:+),
    czesci: parts.size,
    czesci_z_msp: parts.select(&:msp?).size,
    czesci_bez_msp: parts.reject(&:msp?).size
  )
end


Array.class_eval do
  def counts
    each_with_object(Hash.new(0)) do|x, memo|
      key = if block_given?
        yield(x)
      else
        x
      end

      memo[key] += 1
    end
  end
end
