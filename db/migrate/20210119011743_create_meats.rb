class CreateMeats < ActiveRecord::Migration[5.2]
  def change
    create_table :meats do |t|
      t.string :name
      t.string :description
      t.string :image_path

      t.timestamps
    end
  end
end
