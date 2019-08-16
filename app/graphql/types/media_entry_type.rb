module Types
  class MediaEntryType < Types::BaseObject
    field :id, String, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: true
    field :title, String, null: true
    field :url, String, null: true
    field :meta_data,
          MetaDataType.connection_type,
          null: true
    field :media_file, MediaFileType, null: true

    def id
      object.id
    end

    def url
      UrlFor.media_entry(object)
    end
  end
end
