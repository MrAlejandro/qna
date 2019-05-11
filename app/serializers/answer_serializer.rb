class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :question_id, :author_id, :best

  has_many :links, serialiser: LinkSerializer
  has_many :files, serialiser: FileSerializer
end
