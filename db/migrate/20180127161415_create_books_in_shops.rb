class CreateBooksInShops < ActiveRecord::Migration[5.1]
  def change
    create_table :books_in_shops, id: false do |t|
      t.references :book, foreign_key: true, index: true, null: false
      t.references :shop, foreign_key: true, index: true, null: false
      t.integer :sold_count, default: 0
      t.integer :in_stock, default: 0

      t.timestamps
    end
  end
end
