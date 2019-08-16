class Config
  class << self
    YAML.safe_load(File.read('config/settings.yml'))[Rails.env].each do |method, value|
      define_method(method) { value }
    end
  end
end
