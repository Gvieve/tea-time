class CreateTeaSubscriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :tea_subscriptions do |t|
      t.references :subscription, foreign_key: true
      t.references :tea, foreign_key: true
      t.decimal :current_price
      t.integer :quantity
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
