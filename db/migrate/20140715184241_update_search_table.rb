class UpdateSearchTable < ActiveRecord::Migration
  def change
    remove_column :searches, :user_id, :integer
  end
end
