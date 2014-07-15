class UpdateHistoryTable < ActiveRecord::Migration
  def change
    rename_column :histories, :sentiment_score, :sentiment
    remove_column :histories, :sentiment_type, :string
  end
end
