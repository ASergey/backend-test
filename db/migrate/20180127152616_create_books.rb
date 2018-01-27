class CreateBooks < ActiveRecord::Migration[5.1]
  def change
    create_table :books do |t|
      t.references :publisher, foreign_key: true, index: true, null: false
      t.string :title, null: false

      t.timestamps
    end
  end
end
