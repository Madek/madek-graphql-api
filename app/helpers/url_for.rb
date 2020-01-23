class UrlFor
  class << self
    madek_url = Settings[:madek_external_base_url].presence or fail
    %w[collection media_entry preview].each do |method|
      define_method(method) { |object| "#{madek_url}/#{method}/#{object.id}" }
    end
  end
end
