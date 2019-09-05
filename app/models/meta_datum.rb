class MetaDatum < ApplicationRecord

  include Concerns::ContextsHelpers
  include Concerns::MetaData::Filters
  include Concerns::MetaData::SanitizeValue

  belongs_to :meta_key
  has_one :vocabulary, through: :meta_key
  belongs_to :created_by, class_name: 'User'

  # NOTE: need to overwrite the default scope, Rails 5 has '#rescope'
  belongs_to :media_entry, -> { where(is_published: [true, false]) }
  belongs_to :collection, optional: true
  belongs_to :filter_set, optional: true
end
