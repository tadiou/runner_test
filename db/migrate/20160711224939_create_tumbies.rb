class CreateTumbies < ActiveRecord::Migration[5.0]
  def change
    create_table :tumbies do |t|
      t.integer :num

      t.timestamps
    end
  end
end
