module Types
  class PreviewType < Types::BaseObject
    field :id, String, null: false
    field :url, String, null: true
    field :content_type, String, null: true
    field :media_type, Types::PreviewsMediaTypesEnum, null: true
    field :size_class, Types::PreviewSizeClassesEnum, null: true

    def url
      UrlFor.preview(object)
    end

    def media_type
      object.media_type
    end

    def size_class
      object.thumbnail
    end
  end
end
