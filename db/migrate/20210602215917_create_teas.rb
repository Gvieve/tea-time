class CreateTeas < ActiveRecord::Migration[5.2]
  def change
    create_table :teas do |t|
      t.string :title
      t.string :description
      t.float :temperature
      t.integer :brew_time
      t.integer :box_count
      t.decimal :price

      t.timestamps
    end
  end
end
