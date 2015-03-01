require 'http_accept_language'

module LocalesHelper

  def available_locales
    @available_locales ||= I18n.available_locales.map { |name| Locale.new name }
  end

  def selectable_locales
    available_locales.select(&:selectable?)
  end

  def detectable_locales
    available_locales.select(&:detectable?)
  end

  def rtl_locales
    available_locales.select(&:rtl?)
  end

  def incomplete_locales
    available_locales.select(&:incomplete?)
  end

  def selected_locale
    params_selected_locale || user_selected_locale
  end

  def detected_locale
    browser_accepted_locales.map(&:detectable?).first
  end

  def current_locale
    I18n.locale
  end

  def set_application_locale
    I18n.locale = best_locale.to_s
  end

  def locale_fallback(first, second = nil)
    first || second || I18n.default_locale
  end

  def save_detected_locale(user)
    user.update_attribute(:detected_locale, detected_locale)
  end

  def text_direction(object)
    Locale.new(object.try(:locale)).direction
  end

  # View helper methods for language selector dropdown
  def linked_language_options
    language_options_for selectable_locales, link_values: true
  end

  def language_options
    language_options_for selectable_locales, Locale.new, incomplete_locales
  end

  private

  def browser_accepted_locales
    parser = HttpAcceptLanguage::Parser.new(request.env['HTTP_ACCEPT_LANGUAGE'])
    parser.user_preferred_languages & available_locales
  end

  def best_locale
    selected_locale || detected_locale || I18n.default_locale
  end

  def params_selected_locale
    available_locales.find { |locale| locale.name == params[:locale] }
  end

  def user_selected_locale
    available_locales.find { |locale| locale.name == current_user_or_visitor.selected_locale }
  end

  def first_detectable_locale(locales)
    locales.map(&:detectable?).first
  end

  def first_selectable_locale(locales)
    locales.map(&:selectable?).first
  end

  def language_options_for(*locales, link_values: false)
    locales.flatten.map do |locale|
      link_value = url_for(locale: locale) if link_values
      locale.option value: link_value
    end
  end

end
