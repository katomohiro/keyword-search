class CreateWords < ActiveRecord::Migration
  def change
    create_table :words do |t|
      t.string :keyword
      t.text :results
      t.text :saved_words

      t.timestamps null: false
    end
  end
end
