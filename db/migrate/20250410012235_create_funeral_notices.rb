class CreateFuneralNotices < ActiveRecord::Migration[7.1]
  def change
    create_table :funeral_notices do |t|
      t.string :full_name
      t.text :content
      t.date :published_on
      t.string :source_link

      t.timestamps
    end
  end
end
