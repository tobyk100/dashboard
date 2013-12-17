Geocoder.configure({
  timeout: Dashboard::Application::config.geocoder_timeout,
  cache: Rails.cache
})