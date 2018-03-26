class AddNameToRecord < ActiveRecord::Migration[5.2]
  def change
    add_column :records, :name, :string
  end
end
