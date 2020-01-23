DEFAULT_LOCALE = Settings[:madek_default_locale].presence or fail
module Types
  class ContextMetaDataType < Types::BaseObject
    field :id, String, null: false
    field :label, String, null: true
    field :meta_data,
          MetaDataWithContextKeyType.connection_type,
          connection: true, null: true

    def meta_data
      MetaDataWithContextKeyComposer.compose_array_for(object)
    end

    def label
      object.labels[DEFAULT_LOCALE]
    end
  end
end
