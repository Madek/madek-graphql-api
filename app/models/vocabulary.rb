class Vocabulary < ApplicationRecord

  VIEW_PERMISSION_NAME = :view

  include Concerns::Entrust
  include Concerns::PermissionsAssociations
  include Concerns::Vocabularies::AccessScopesAndHelpers
  include Concerns::Vocabularies::Filters
  include Concerns::Orderable
  include Concerns::LocalizedFields

  enable_ordering
  localize_fields :labels, :descriptions

  has_many :meta_keys
  has_many :keywords,
           through: :meta_keys

  scope :sorted, lambda { |locale = AppSetting.default_locale|
    unscoped.order("vocabularies.labels->'#{locale}'")
  }
  scope :with_meta_keys_count, lambda {
    joins('LEFT OUTER JOIN meta_keys ON meta_keys.vocabulary_id = vocabularies.id')
      .select('vocabularies.*, count(meta_keys.id) AS meta_keys_count')
      .group('vocabularies.id')
  }
end
