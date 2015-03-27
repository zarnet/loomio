class MemoSerializer < ActiveModel::Serializer
  embed :ids, include: true
  attributes :kind, :data
end
