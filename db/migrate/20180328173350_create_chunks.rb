class CreateChunks < ActiveRecord::Migration[5.2]
  def change
    create_table :chunks do |t|
      t.integer :record_id
      t.integer :start_at
      t.string :source

      t.timestamps
    end
  end
end
