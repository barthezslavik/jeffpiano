class AddDurationToRecord < ActiveRecord::Migration[5.2]
  def change
    add_column :records, :duration, :integer
  end
end
