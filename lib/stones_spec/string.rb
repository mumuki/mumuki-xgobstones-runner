class String
  def start_with_lowercase?
    first_letter = self[0]
    first_letter.downcase == first_letter
  end

  def include_any?(other_strs)
    other_strs.any? { |other| include? other }
  end
end