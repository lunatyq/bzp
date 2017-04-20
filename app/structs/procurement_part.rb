class ProcurementPart
  vattr_initialize :data

  def contractors
    raw_contractors.map { |rc| Contractor.new(rc.with_indifferent_access) }
  end

  def raw_contractors
    data['wykonawcy'].sort_by(&:first).map(&:last)
  end
end
