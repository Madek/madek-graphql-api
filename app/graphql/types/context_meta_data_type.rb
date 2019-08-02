# frozen_string_literal: true

module Types
  class ContextMetaDataType < Types::BaseObject
    field :id, String, null: false
    field :label, String, null: true
    field :meta_data,
          MetaDataWithContextKeyType.connection_type,
          connection: true,
          null: true

    def meta_data
      MetaDataWithContextKeyComposer.compose_array_for(object)
    end

    def label
      object.labels[Config.locale]
    end
  end
end
