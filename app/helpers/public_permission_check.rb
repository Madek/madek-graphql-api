# frozen_string_literal: true

class PublicPermissionCheck
  def self.for(object)
    MadekErrors::NotPublic.new(object) unless object.get_metadata_and_previews
  end
end
