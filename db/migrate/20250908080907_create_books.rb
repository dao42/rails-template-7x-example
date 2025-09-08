class CreateBooks < ActiveRecord::Migration[7.2]
  def change
    create_table :books do |t|
      t.string :title
      t.string :author
      t.decimal :price, precision: 10, scale: 2
      t.text :description
      t.string :cover_image
      t.string :isbn
      t.integer :stock

      t.timestamps
    end
  end
end
