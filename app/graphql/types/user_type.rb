module Types
  class UserType < Types::BaseObject
    field :id, String, null: false
    field :login, String, null: false
    field :institutional_id, String, null: true

    field :is_responsible_for_entries, [MediaEntryType], null: true

    def is_responsible_for_entries
      MediaEntry.where(responsible_user: object.id)
    end
  end
end
