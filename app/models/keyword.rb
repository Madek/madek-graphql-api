class Keyword < ApplicationRecord

  include Concerns::FindResource
  include Concerns::Keywords::Filters
  include Concerns::Orderable

  enable_ordering skip_default_scope: true,
                  parent_scope: :meta_key

  belongs_to :meta_key
  belongs_to :creator, class_name: 'User'
  has_and_belongs_to_many :meta_data, join_table: :meta_data_keywords
  has_many :meta_data_keywords, class_name: '::MetaDatum::Keyword'

  def to_s
    term
  end

  def self.viewable_by_user_or_public(user = nil)
    viewable_vocabs = Vocabulary.viewable_by_user_or_public(user)
    joins(:meta_key)
      .where('meta_keys.vocabulary_id IN (?)', viewable_vocabs.map(&:id))
  end

  def self.with_usage_count
    select('keywords.*, count(meta_data_keywords.id) AS usage_count')
      .joins('INNER JOIN meta_data_keywords ' \
             'ON meta_data_keywords.keyword_id = keywords.id')
      .group('keywords.id')
      .reorder('usage_count DESC')
  end

  # used in explore catalog
  def self.for_meta_key_and_used_in_visible_entries_with_previews(meta_key,
                                                                  user,
                                                                  limit)
    with_usage_count
      .where(meta_key: meta_key)
      .joins('INNER JOIN meta_data ' \
             'ON meta_data.id = meta_data_keywords.meta_datum_id')
      .where(
        meta_data: {
          media_entry_id: MediaEntry
                          .viewable_by_user_or_public(user)
                          .joins(:media_file)
                          .joins('INNER JOIN previews ' \
                                 'ON previews.media_file_id = media_files.id')
                          .where(previews: { media_type: 'image' })
        }
      )
      .limit(limit)
  end
end
