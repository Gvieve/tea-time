class CreateSubscriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :subscriptions do |t|
      t.references :user, foreign_key: true
      t.string :name
      t.integer :status, default: 0
      t.date :process_on_date
      t.references :plan, foreign_key: true

      t.timestamps
    end
  end
end
