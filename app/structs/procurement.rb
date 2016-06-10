class Procurement
  vattr_initialize :data

  def contractors
    parts.map { |p| p.contractors }
  end

  def parts
    data['czesci'].values.map { |part| ProcurementPart.new(part.with_indifferent_access) }
  end
end
