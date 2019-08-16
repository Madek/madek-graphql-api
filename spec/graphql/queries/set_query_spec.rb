describe 'getCollection' do
  before(:each) do
    set_collection
  end

  let(:collection_keys) { %w[id url metaData childMediaEntries] }
  let(:media_entry_keys) { %w[id url metaData mediaFile] }
  let(:media_file_keys) { %w[previews] }
  let(:preview_keys) { %w[id url contentType mediaType sizeClass] }
  let(:meta_data_keys) { %w[id metaKey values] }
  let(:query) { QueriesHelpers::CollectionQuery.new.query }
  let(:variables) do
    { 'id' => @collection.id,
      'mediaEntriesMediaTypes' => %w[IMAGE AUDIO],
      'previewsMediaTypes' => %w[IMAGE AUDIO] }
  end
  let(:response_collection) { response_to_h(query, variables)['data']['set'] }
  let(:response_media_entry) { sample_node_of(response_collection['childMediaEntries']) }
  let(:response_media_file) { response_media_entry['mediaFile'] }
  let(:response_media_file_preview) { sample_node_of(response_media_file['previews']) }

  it 'loads collections by ID' do
    expect(response_collection['id']).to eq(@collection.id)
    expect(response_collection.keys).to eq(collection_keys)
  end

  it "returns collections' media entries as relay connection" do
    expect(response_media_entry.keys).to eq(media_entry_keys)
  end

  it 'returns collection with only publicly visible media entries' do
    media_entries = @collection.media_entries
    media_entries.last.update(get_metadata_and_previews: false)

    expect(response_collection['childMediaEntries']['edges'].size)
      .to eq(@collection.media_entries.public_visible.size)
  end

  it 'returns media file for each media entry' do
    expect(response_media_file.keys).to eq(%w[previews])
  end

  it "returns media file's previews as relay connection" do
    expect(response_media_file_preview.keys).to eq(preview_keys)
  end

  it 'returns meta data for collection and media entries as relay connection' do
    expect(sample_node_of(response_collection['metaData']).keys)
      .to eq(meta_data_keys)
    expect(sample_node_of(response_collection['metaData'])['metaKey']['id'])
      .to be
    expect(sample_node_of(response_collection['metaData'])['values'][0]['string'])
      .to be
    expect(sample_node_of(response_media_entry['metaData']).keys)
      .to eq(meta_data_keys)
    expect(sample_node_of(response_media_entry['metaData'])['metaKey']['id'])
      .to be
    expect(sample_node_of(response_media_entry['metaData'])['values'][0]['string'])
      .to be
  end
end
