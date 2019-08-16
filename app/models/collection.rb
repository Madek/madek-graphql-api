class Collection < ApplicationRecord
  ################################################################################
  # NOTE: The standard `find` and `find_by_id` methods are extended/overridden in
  # app/models/concerns/media_resources/custom_urls in order to accomodate
  # custom_ids. One can thus search for a particular resource using either its
  # uuid or custom_id.
  # There are two possible use cases:
  # 1. raise if resource is not found => use `find`
  # 2. return nil if resource is not found => use `find_by_id`
  #
  # `find_by(...)` or `find_by!(...)` are DISABLED. If you want to further
  # narrow down the scope when searching with a custom_id then do it this way:
  # Ex. `Collection
  #        .joins(:custom_urls)
  #        .where(custom_urls: { is_primary: true })
  #        .find('custom_id')
  ################################################################################

  VIEW_PERMISSION_NAME = :get_metadata_and_previews
  EDIT_PERMISSION_NAME = :edit_metadata_and_relations
  MANAGE_PERMISSION_NAME = :edit_permissions

  include Concerns::Collections::Arcs
  include Concerns::Collections::Siblings
  include Concerns::MediaResources
  include Concerns::MediaResources::CustomOrderBy
  include Concerns::MediaResources::Editability
  include Concerns::MediaResources::Highlight
  include Concerns::MediaResources::MetaDataArelConditions
  include Concerns::SharedOrderBy
  include Concerns::SharedScopes

  #################################################################################

  has_many :media_entries, through: :collection_media_entry_arcs

  has_many :highlighted_media_entries,
           through: :collection_media_entry_highlighted_arcs,
           source: :media_entry

  #################################################################################

  has_many :collections,
           through: :collection_collection_arcs_as_parent,
           source: :child

  has_many :highlighted_collections,
           through: :collection_collection_highlighted_arcs,
           source: :child

  has_many :parent_collections,
           through: :collection_collection_arcs_as_child,
           source: :parent

  #################################################################################

  has_many :filter_sets, through: :collection_filter_set_arcs

  has_many :highlighted_filter_sets,
           through: :collection_filter_set_highlighted_arcs,
           source: :filter_set

  #################################################################################

  scope :by_title, lambda{ |title|
    joins(:meta_data)
      .where(meta_data: { meta_key_id: 'madek_core:title' })
      .where('string ILIKE :title', title: "%#{title}%")
      .order(:created_at, :id)
  }
end
