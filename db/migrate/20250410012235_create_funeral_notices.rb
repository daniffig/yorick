class CreateFuneralNotices < ActiveRecord::Migration[7.1]
  def change
    create_table :funeral_notices do |t|
      t.string :full_name
      t.text :content
      t.date :published_on
      t.string :source_link
      t.string :hash_id

      t.timestamps
    end

    add_index :funeral_notices, :hash_id, unique: true
    add_index :funeral_notices, [:published_on, :hash_id]
    add_index :funeral_notices, :published_on, order: { published_on: :desc }
  end
end
