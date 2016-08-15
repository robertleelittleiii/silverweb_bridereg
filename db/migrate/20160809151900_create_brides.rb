class CreateBrides < ActiveRecord::Migration
  def change
    create_table :brides do |t|
      t.integer :user_id
      t.date :wedding_date
      t.string :groom_full_name

      t.timestamps null: false
    end
  end
end
