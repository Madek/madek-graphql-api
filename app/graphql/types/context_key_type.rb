# frozen_string_literal: true

module Types
  class ContextKeyType < Types::BaseObject
    field :id, String, null: false
    field :label, String, null: true
    field :position, String, null: false
    field :description, String, null: false
    field :meta_key, MetaKeyType, null: true

    def meta_key
      object.meta_key
    end
  end
end
