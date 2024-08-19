class CreateLinks < ActiveRecord::Migration[7.1]
  def change
    create_table :link do |t|
      t.string :url
      t.string :slug
      t.integer :clicked, default: 0
      t.timestamps null: false
    end
  end
end
