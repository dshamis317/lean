class CreateHistories < ActiveRecord::Migration
  def change
    create_table :histories do |t|
      t.string :sentiment_type
      t.float :sentiment_score
      t.references :feed, index: true
      t.references :search, index: true

      t.timestamps
    end
  end
end
