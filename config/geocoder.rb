require 'geocoder'

module ReplaceFreegeoipHostModule
  
  def self.included base
    base.class_eval do
    
      def query_url(query)
        "#{protocol}://#{Dashboard::Application::config.geocoder_server}/json/#{query.sanitized_text}"
      end
      
    end
  end

end

Geocoder::Lookup::Freegeoip.send(:include,ReplaceFreegeoipHostModule)
