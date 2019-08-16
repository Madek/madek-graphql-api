describe MadekGraphqlSchema do
  let(:current_defn) { MadekGraphqlSchema.to_definition }
  let(:printout_defn) { File.read(Rails.root.join('app/graphql/schema.graphql')) }

  it 'allows queries 20 levels deep' do
    collection = create(:collection)
    fill_collection_with_nested_collections(collection, 10)
    query = QueriesHelpers::CollectionQuery.new(10).query
    variables = { 'id' => collection.id,
                  'mediaEntriesMediaTypes' => %w[IMAGE AUDIO],
                  'previewsMediaTypes' => %w[IMAGE AUDIO] }
    response = response_to_h(query, variables)

    expect(response['errors'].first['message'])
      .to include('exceeds max depth of 25')
  end

  it 'should be updated after any changes' do
    expect(current_defn).to eq(printout_defn),
                            "Update the printed schema with `bundle exec rake dump_graphql_schema`
                                              * BUT FIRST *
                            make sure that you have not made any breaking change"
  end

  context 'media entries' do
    let(:media_entry) { create(:media_entry_with_title) }
    let(:variables) do
      { 'id' => media_entry.id,
        'mediaEntriesMediaTypes' => ['AUDIO'],
        'previewsMediaTypes' => ['IMAGE'] }
    end
    let(:result) { response_data(media_entry_query, variables) }

    it 'loads media entries by ID' do
      expect(result['mediaEntry']['id']).to eq(media_entry.id)
    end
  end
end
