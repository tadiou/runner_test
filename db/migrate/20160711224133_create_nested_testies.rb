class CreateNestedTesties < ActiveRecord::Migration[5.0]
  def change
    create_table :nested_testies do |t|
      t.integer :num

      t.timestamps
    end
  end
end
