class CreatePlans < ActiveRecord::Migration[5.2]
  def change
    create_table :plans do |t|
      t.string :description
      t.integer :weekly_frequency

      t.timestamps
    end
  end
end
