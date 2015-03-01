Locale = Struct.new :name do
  def selectable?
    @selectable ||= Loomio::I18n::SELECTABLE_LOCALES.include? name
  end

  def detectable?
    @detectable ||= Loomio::I18n::DETECTABLE_LOCALES.include? name
  end

  def rtl?
    @rtl ||= Loomio::I18n::RTL_LOCALES.include? name
  end

  def incomplete?
    rtl? && !selectable?
  end

  def direction
    rtl? ? 'RTL' : 'LTR'
  end

  def option_name
    prefix = incomplete? ? "incomplete: " : ""
    prefix + I18n.t(name.to_sym, scope: :native_language_name)
  end

  def option(value: nil)
    if name
      [option_name, value || name]
    else
      ['---------------------------------', 'disabled_option']
    end
  end

  def to_s
    name.to_s
  end

  def ==(other)
    self.name == other.name if other.is_a? Locale
  end

end