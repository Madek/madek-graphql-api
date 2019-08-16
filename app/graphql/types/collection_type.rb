module Types
  class CollectionType < Types::BaseObject
    field :id, String, null: false
    field :get_metadata_and_previews, Boolean, null: true
    field :created_at, GraphQL::Types::ISO8601DateTime, null: true
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: true
    field :layout, String, null: true
    field :sorting, String, null: true
    field :responsible_user_id, String, null: true
    field :url, String, null: true
    field :meta_data,
          MetaDataType.connection_type,
          null: true

    field :child_media_entries,
          MediaEntryType.connection_type,
          null: true,
          connection: true do
      argument :orderBy,
               Types::OrderByEnum,
               required: false
      argument :media_types,
               [Types::MediaEntryMediaTypesEnum],
               required: false
    end

    field :sets,
          CollectionType.connection_type,
          null: true,
          connection: true do
      argument :orderBy,
               Types::OrderByEnum,
               required: false
    end

    def meta_data
      object.meta_data.of_type('text')
    end

    def child_media_entries(order_by: 'CREATED_AT desc', media_types: 'image')
      object.media_entries.public_visible
            .joins(:media_file)
            .where(media_files: { media_type: media_types })
            .order(order_by)
    end

    def sets
      object.collections
    end

    def url
      UrlFor.collection(object)
    end
  end
end
