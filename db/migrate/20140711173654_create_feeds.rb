class CreateFeeds < ActiveRecord::Migration
  def change
    create_table :feeds do |t|
      t.references :topic, index: true
      t.string :name
      t.string :url

      t.timestamps
    end
  end
end
