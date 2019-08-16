class UrlFor
  class << self
    %w[collection media_entry preview].each do |method|
      define_method(method) do |object|
        "#{Config.madek_url}/#{method}/#{object.id}"
      end
    end
  end
end
