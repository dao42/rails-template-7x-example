class CreateOrders < ActiveRecord::Migration[7.2]
  def change
    create_table :orders do |t|
      t.references :book, null: false, foreign_key: true
      t.string :customer_email
      t.string :customer_name
      t.decimal :total_amount, precision: 10, scale: 2
      t.string :stripe_payment_intent_id
      t.string :status
      t.datetime :purchased_at

      t.timestamps
    end
  end
end
