module Types
  class MetaDataType < Types::BaseObject
    field :id, String, null: true
    field :metaKey, MetaKeyType, null: true
    field :values, [ValueType], null: true

    def values
      [object.value]
    end
  end
end
