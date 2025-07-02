class FuneralNotice < ApplicationRecord
  validates :full_name, :content, :published_on, :source_link, presence: true
  validates :hash_id, presence: true, uniqueness: true, if: :persisted?

  update_index 'funeral_notices'

  before_validation :generate_hash_id, on: :create

  def pathname
    date_str = published_on.strftime('%Y-%m-%d')
    name_dasherized = full_name.parameterize
    "#{date_str}/#{name_dasherized}-#{hash_id}"
  end

  def route_params
    {
      date: published_on.strftime('%Y-%m-%d'),
      name_hash: "#{full_name.parameterize}-#{hash_id}"
    }
  end

  def generate_hash_id
    return if hash_id.present?

    # Create a hash based on date, content, and a random component
    content_to_hash = "#{published_on}#{full_name}#{content}#{SecureRandom.hex(4)}"
    self.hash_id = Digest::SHA256.hexdigest(content_to_hash)[0..5] # 6 characters
  end
end
