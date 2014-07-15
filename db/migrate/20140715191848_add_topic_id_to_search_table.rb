class AddTopicIdToSearchTable < ActiveRecord::Migration
  def change
    add_column :searches, :topic_id, :integer
  end
end
