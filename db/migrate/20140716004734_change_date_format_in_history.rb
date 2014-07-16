class ChangeDateFormatInHistory < ActiveRecord::Migration
  def change
    add_column :histories, :date, :string
  end
end
