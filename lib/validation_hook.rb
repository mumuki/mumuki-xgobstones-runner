class GobstonesValidationHook < Mumukit::Hook
  def validate!(request)
    validate_ascii_at! request, :content
    validate_ascii_at! request, :extra
  end

  def validate_ascii_at!(request, key)
    string = request[key]
    raise Mumukit::RequestValidationError,
          I18n.t(:non_ascii_character, key: key, near: string.non_ascii_context(8)) unless string.ascii?
  end
end
