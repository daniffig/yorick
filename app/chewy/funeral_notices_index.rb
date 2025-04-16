class FuneralNoticesIndex < Chewy::Index
  index_scope FuneralNotice

  field :id, type: :integer
  field :full_name, type: :text, analyzer: :standard
  field :content, type: :text, analyzer: :standard
  field :published_on, type: :date
end
