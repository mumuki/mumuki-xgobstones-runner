class String
  def ascii?
    each_byte.all? { |c| c < 128 }
  end

  def non_ascii_context(size)
    gsub(/(.{0,#{size}}[^\p{ASCII}]+.{0,#{size}})/).first.try { |it| "...#{it}..." }
  end
end
