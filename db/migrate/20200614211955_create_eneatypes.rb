class CreateEneatypes < ActiveRecord::Migration[6.0]
  def change
    create_table :eneatypes do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.integer :number
      t.integer :score

      t.timestamps
    end
  end
end
