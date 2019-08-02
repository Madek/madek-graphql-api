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
end
