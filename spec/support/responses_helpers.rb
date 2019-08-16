module ResponsesHelpers
  def stringified_created_ats_from_response(response)
    response.map do |media_entry|
      ActiveSupport::TimeZone['UTC'].parse(media_entry['createdAt']).to_s
    end
  end

  def response_to_h(query, variables)
    MadekGraphqlSchema.execute(query, variables: variables).to_h
  end

  def response_data(query, variables)
    response_to_h(query, variables)['data']
  end

  def node_from_nested_connection(response, name, depth)
    depth.times do
      break unless response

      response = response[name] ? response[name]['edges'][0]['node'] : nil
    end
    response
  end

  def sample_node_of(response_hash)
    response_hash.dig('edges', 0, 'node')
  end
end
