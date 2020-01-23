describe 'Request-based GraphQL integration tests', type: :request do
  example 'basic introspection works' do
    doc = <<-GRAPHQL
      query { __schema { queryType { name } } }
    GRAPHQL

    result = graphql_request(doc).result

    expect(result[:errors]).not_to be_present

    expect(result).to eq(data: { __schema: { queryType: { name: 'Query' } } })
  end

  context 'correct error handling' do
    example 'no document', type: :request do
      expect(graphql_request('').result).to eq(
        errors: [{ message: 'No `query` parameter given!' }]
      )
    end

    example 'invalid document', type: :request do
      expect(graphql_request('INVALID_DOCUMENT').result).to eq(
        errors: [
          {
            locations: [{ column: 1, line: 1 }],
            message: 'Parse error on "INVALID_DOCUMENT" (IDENTIFIER) at [1, 1]'
          }
        ]
      )
    end

    context 'variables' do
      let(:doc) do
        <<-GRAPHQL
        query typeByName($myTypeName: String!) { __type(name: $myTypeName) { name } }
        GRAPHQL
      end

      it 'works' do
        vars = { myTypeName: 'Query' }
        expect(graphql_request(doc, vars).result).to eq(
          data: { __type: { name: 'Query' } }
        )
      end

      example 'error for missing variable' do
        result = graphql_request(doc, {}).result
        expect(result[:errors].count).to be 1
        expect(result[:errors].first.slice(:locations, :message)).to eq(
          locations: [{ column: 26, line: 1 }],
          message:
            'Variable $myTypeName of type String! was provided invalid value'
        )
      end

      example 'error for wrong variable type' do
        result = graphql_request(doc, myTypeName: 1_234).result
        expect(result[:errors].count).to be 1
        expect(result[:errors].first.slice(:locations, :message)).to eq(
          locations: [{ column: 26, line: 1 }],
          message:
            'Variable $myTypeName of type String! was provided invalid value'
        )
      end
    end
  end
end
