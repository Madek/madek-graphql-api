class Person < ApplicationRecord
  include Concerns::FindResource
  include Concerns::People::Filters

  self.inheritance_column = false

  default_scope { reorder(:last_name) }
  scope :subtypes, -> { unscoped.select(:subtype).distinct }

  has_one :user

  has_and_belongs_to_many :meta_data, join_table: :meta_data_people
  has_many :meta_data_people, class_name: '::MetaDatum::Person'
  has_and_belongs_to_many :roles, join_table: :meta_data_roles


  def to_s
    case
    when ((first_name or last_name) and (pseudonym and !pseudonym.try(:empty?)))
      "#{first_name} #{last_name} (#{pseudonym})".strip
    when (first_name or last_name)
      "#{first_name} #{last_name}".strip
    else
      pseudonym.strip
    end
  end

  def self.for_meta_key_and_used_in_visible_entries_with_previews(meta_key,
                                                                  user,
                                                                  limit)
    joins(meta_data: :meta_key)
      .where(meta_keys: { id: meta_key.id })
      .where(
        meta_data: {
          media_entry_id: MediaEntry
                          .viewable_by_user_or_public(user)
                          .joins(media_file: :previews)
                          .where(previews: { media_type: 'image' })
        }
      )
      .limit(limit)
  end
end
