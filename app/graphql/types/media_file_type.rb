module Types
  class MediaFileType < Types::BaseObject
    field :previews,
          PreviewType.connection_type,
          null: true,
          connection: true do
      argument :media_types,
               [Types::PreviewsMediaTypesEnum],
               required: false
    end

    def previews(media_types: 'image')
      object.previews.where(media_type: media_types)
    end
  end
end
