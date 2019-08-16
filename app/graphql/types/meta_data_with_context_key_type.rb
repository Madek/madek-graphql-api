module Types
  class MetaDataWithContextKeyType < Types::BaseObject
    # field :id, String, null: false
    # todo ID of what?

    field :meta_datum, [MetaDataType], null: true
    field :context_key, ContextKeyType, null: true

    def meta_datum
      object[:meta_data]
    end

    def context_key
      object[:context_key]
    end
  end
end
