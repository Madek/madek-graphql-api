# frozen_string_literal: true

describe 'Set query', type: :request do
  before(:each) do
    set_collection
  end

  let(:query) { QueriesHelpers::CollectionQuery.new.query }
  let(:vars) do
    { 'id' => @collection.id,
      'mediaEntriesMediaTypes' => %w[IMAGE AUDIO],
      'previewsMediaTypes' => %w[IMAGE AUDIO] }
  end

  example 'query id' do
    query = <<-'GRAPHQL'
      query getSet($id: ID!) {
        set(id: $id) {
          id
        }
      }
    GRAPHQL

    expect(graphql_request(query, vars).result).to eq(
      data: { set: { id: @collection.id } }
    )
  end

  example 'query all publicly available media_entries from collection' do
    collection_size = @collection.media_entries.size
    @image_media_entry_1.update(get_metadata_and_previews: false)

    collection_media_entries_ids = @collection.media_entries.public_visible.ids
    collection_previews_ids = @collection.media_entries.public_visible
      .map { |me| me.media_file.previews.ids }.flatten
    collection_meta_data_ids = @collection.media_entries.public_visible
      .map { |me| me.meta_data.ids }.flatten

    result = graphql_request(query, vars).result
    result_previews_ids = []
    result_meta_data_ids = []
    result_me = result[:data][:set][:childMediaEntries][:edges]
    result_me.each do |me|
      me[:node][:mediaFile][:previews][:edges]
        .map { |e| result_previews_ids << e[:node][:id] }
      me[:node][:metaData][:edges]
        .map { |e| result_meta_data_ids << e[:node][:id] }
    end

    expect(result[:errors]).to be_nil
    expect(result_me.size).to eq(collection_size - 1)

    expect(result_previews_ids).to match_array(collection_previews_ids)
    expect(result_meta_data_ids).to match_array(collection_meta_data_ids)

    result_me.each do |me|
      # Should audio file have any preview here?
      # I see in factory that it should.
      unless audio?(me)
        expect(me[:node][:mediaFile][:previews][:edges]).not_to be_empty
        expect(me[:node][:mediaFile][:previews][:edges].sample[:node].keys)
          .to eq [:id, :url, :contentType, :mediaType, :sizeClass]
      end

      expect(collection_media_entries_ids).to include(me[:node][:id])
      expect(me[:node][:metaData]).not_to be_empty
      expect(me[:node].keys).to eq [:id, :url, :metaData, :mediaFile]
      expect(me[:node][:metaData][:edges].sample[:node].keys)
        .to eq [:id, :metaKey, :values]
    end
  end

  example 'query publicly available media entries from collection by media type' do
    vars['mediaEntriesMediaTypes'] = vars['previewsMediaTypes'] = ['AUDIO']

    result = graphql_request(query, vars).result
    result_me = result[:data][:set][:childMediaEntries][:edges]

    expect(result[:errors]).to be_nil
    expect(result_me.size).to eq(1)
    expect(result_me[0][:node][:id]).to eq(@audio_media_entry.id)
  end

  example 'query entries from collection by ordered by creation date' do
    vars['orderBy'] = 'CREATED_AT_DESC'
    initial_order = graphql_request(query, vars)
      .result[:data][:set][:childMediaEntries][:edges].map { |e| e[:node][:id] }
    vars['orderBy'] = 'CREATED_AT_ASC'
    reversed_order = graphql_request(query, vars)
      .result[:data][:set][:childMediaEntries][:edges].map { |e| e[:node][:id] }

    expect(initial_order.reverse).to match(reversed_order)
  end

  def audio?(me)
    MediaEntry.find(me[:node][:id]).media_file.media_type == 'audio'
  end
end
