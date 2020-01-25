class MetaDatum::JSON < MetaDatum::Text

  def value
    json.to_json
  end

end
