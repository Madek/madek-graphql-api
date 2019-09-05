class Preview < ApplicationRecord
  include Concerns::MediaType

  attr_accessor :accessed_by_confidential_link

  belongs_to :media_file, touch: true

  before_create :set_media_type
end
