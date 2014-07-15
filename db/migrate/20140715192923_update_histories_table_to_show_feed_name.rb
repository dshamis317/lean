class UpdateHistoriesTableToShowFeedName < ActiveRecord::Migration
  def change
    remove_column :histories, :feed_id, :integer
    add_column :histories, :feed_name, :string
  end
end
