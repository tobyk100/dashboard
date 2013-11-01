module LocaleHelper

  # Symbol of best valid locale code to be used for I18n.locale.
  def locale
    best = candidate_locales.find { |locale|
      Dashboard::Application::LOCALES.has_key? locale
    }
    # Expand language codes to include regions, if applicable.
    data = Dashboard::Application::LOCALES[best]
    data.fetch(:expand, best).to_sym
  end

  # String representing the 2 letter language code.
  # Prefer full locale with region where possible.
  def language
    locale.to_s.split('-').first
  end

  # String representing the Locale code for the Blockly client code.
  def js_locale
    locale.to_s.downcase.gsub('-', '_')
  end

  def options_for_locale_select
    options = []
    Dashboard::Application::LOCALES.each do |locale, data|
      if I18n.available_locales.include? locale.to_sym
        options << [data[:name], locale]
      end
    end
    options
  end

  # returns true if we support their first choice of locale
  def support_primary_locale?
    locales = Dashboard::Application::LOCALES.select do |k,v|
      v.fetch(:enabled, true)
    end
    languages = locales.keys.map do |key|
      key.split('-').first
    end
    languages.include? candidate_locales.first.split('-').first
  end

  private

  # Parses and ranks locale code strings from the Accept-Language header.
  def accepted_locales
    header = request.env.fetch('HTTP_ACCEPT_LANGUAGE', '')
    begin
      header.split(',').map { |entry|
        locale, weight = entry.split(';')
        weight = (weight || 'q=1').split('=')[1].to_f
        [locale, weight]
      }.sort_by { |locale, weight| -weight
      }.map { |locale, weight| locale.strip }
    rescue
      Logger.warn "Error parsing Accept-Language header: #{header}"
      []
    end
  end

  # Strips regions off of accepted_locales.
  def accepted_languages
    accepted_locales.map { |locale| locale.split('-')[0] }
  end

  # Provides a prioritized list of possible locale codes as strings.
  def candidate_locales
    ([session[:locale], current_user.try(:locale)] +
     accepted_locales + accepted_languages +
     [I18n.default_locale]
    ).reject(&:nil?).map(&:to_s)
  end

  # Looks up a localized string driven by a database value.
  # See config/locales/data.en.yml for details.
  def data_t(dotted_path, key)
    I18n.t("data.#{dotted_path}")[key.to_sym]
  end

end
