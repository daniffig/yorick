class FuneralNoticesIndex < Chewy::Index
  index_scope FuneralNotice

  field :id, type: :integer
  field :full_name, type: :text, analyzer: :standard
  field :content, type: :text, analyzer: :standard
  field :published_on, type: :date
  field :created_at, type: :date
  field :updated_at, type: :date
end
