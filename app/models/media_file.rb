class MediaFile < ApplicationRecord
  include Concerns::MediaType
  #include Concerns::MediaFiles::Filters
  #include Concerns::MediaFiles::Sorters

  ## include MediaFileModules::FileStorageManagement
  ## include MediaFileModules::Previews
  ## include MediaFileModules::MetaDataExtraction

  belongs_to :media_entry, -> { where(is_published: false) },
             foreign_key: :media_entry_id
  has_many :zencoder_jobs, -> { order(created_at: :desc) },
           dependent: :destroy
  belongs_to :uploader, class_name: 'User'

  has_many :previews, -> { order(:created_at, :id) }, dependent: :destroy

  scope :incomplete_encoded_videos, lambda {
    where(media_type: 'video').where \
      'NOT EXISTS (SELECT NULL FROM media_files as mf ' \
                  'INNER JOIN previews ON previews.media_file_id = mf.id ' \
                  "WHERE mf.id = media_files.id AND previews.media_type = 'video')"
  }
end
