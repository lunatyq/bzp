class ProcurementPart
  vattr_initialize :data

  def contractors
    raw_contractors.map { |rc| Contractor.new(rc.with_indifferent_access) }
  end

  def msp?
    smb_offers > 0
  end

  def cancelled?
    data['czy_postepowanie_uniewazniono'] == 'T'
  end

  def smb_offers
    data['liczba_otrzymanych_ofert_msp'].to_i
  end

  def offers
    data['liczba_ofert'].to_i
  end

  def raw_contractors
    data['wykonawcy'].sort_by(&:first).map(&:last)
  end
end
