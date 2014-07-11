class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      t.references :user, index: true
      t.string :keyword

      t.timestamps
    end
  end
end
