class CreateUserInstitutions < ActiveRecord::Migration[6.0]
  def change
    create_table :user_institutions do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :institution, null: false, foreign_key: true
    end
  end
end
