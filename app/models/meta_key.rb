class MetaKey < ApplicationRecord

  include Concerns::MetaKeys::Filters
  include Concerns::Orderable
  include Concerns::LocalizedFields

  has_many :meta_data, dependent: :destroy
  belongs_to :vocabulary
  has_many :context_keys
  has_many :roles

  enum text_type: { line: 'line', block: 'block' }

  #################################################################################
  # NOTE: order of statements is important here! ##################################
  #################################################################################
  # (1.)
  has_many :keywords

  # (2.) override one of the methods provided by (1.)
  def keywords
    ks = Keyword.where(meta_key_id: id)
    if keywords_alphabetical_order
      ks.order('keywords.term ASC')
    else
      ks.order('keywords.position ASC')
    end
  end
  #################################################################################

  scope :order_by_name_part, lambda {
    reorder("substring(meta_keys.id FROM ':(.*)$') ASC, meta_keys.id")
  }
  scope :with_keywords_count, lambda {
    joins(
      'LEFT OUTER JOIN keywords ON
       keywords.meta_key_id = meta_keys.id'
    )
      .select('meta_keys.*, count(keywords.id) as keywords_count')
      .group('meta_keys.id')
  }

  enable_ordering parent_scope: :vocabulary
  localize_fields :labels, :descriptions, :hints
end
