# mini-route-map for madek-webapp
ROUTES = { collection: 'sets', media_entry: 'entries', preview: 'media' }

class UrlFor
  class << self
    madek_url = Settings[:madek_external_base_url].presence or fail

    ROUTES.each do |method, path_seg|
      define_method(method) { |object| "#{madek_url}/#{path_seg}/#{object.id}" }
    end
  end
end
