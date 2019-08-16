module Types
  class ValueType < Types::BaseObject
    field :string, String, null: true

    def string
      object
    end
  end
end
