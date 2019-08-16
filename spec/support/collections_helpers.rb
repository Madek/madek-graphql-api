module CollectionsHelpers
  def fill_collection_with_nested_collections(collection, depth)
    depth.times do
      collection.collections << create(:collection)
      collection = collection.collections.last
    end
  end

  def fill_collection_with_media_entries(collection, collection_size)
    collection.media_entries = create_list(:media_entry_with_title,
                                           collection_size)
  end

  def fill_collection_with_media_entries_with_images(collection, collection_size)
    collection.media_entries = create_list(:media_entry_with_image_media_file,
                                           collection_size)
  end

  def add_meta_data_titles_to_collection_media_entries(collection)
    collection.media_entries.each do |me|
      create(:meta_datum_title, media_entry: me)
    end
  end

  def set_collection
    @collection = create(:collection, get_metadata_and_previews: true)
    create(:meta_datum_title_with_collection, collection: @collection)
    @image_media_entry_1 = create :media_entry_with_image_media_file
    @audio_media_entry = create :media_entry_with_audio_media_file
    @image_media_entry_2 = create :media_entry_with_image_media_file
    @collection.media_entries = [@image_media_entry_1,
                                 @audio_media_entry,
                                 @image_media_entry_2]
    add_meta_data_titles_to_collection_media_entries(@collection)
  end
end
