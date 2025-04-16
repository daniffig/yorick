class FuneralNotice < ApplicationRecord
  validates :full_name, :content, :published_on, :source_link, presence: true

  update_index 'funeral_notices'
end
