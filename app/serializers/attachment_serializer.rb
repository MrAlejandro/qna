class AttachmentSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :file_name, :path

  def file_name
    object.filename.to_s
  end

  def path
    rails_blob_path(object, only_path: true)
  end
end
