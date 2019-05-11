class FileSerializer < ActiveModel::Serializer
  has_many :attachments, serializer: AttachmentSerializer
end
