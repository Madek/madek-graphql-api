describe 'IntrospectionQuery' do
  it 'responds without error' do
    (query = GraphQL::Introspection::INTROSPECTION_QUERY.presence) || raise
    response = response_to_h(query, {})

    expect(response['data']['__schema']).not_to be_empty
  end
end
