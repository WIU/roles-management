class CreateOus < ActiveRecord::Migration
  def change
    create_table :ous do |t|
      t.string :name

      t.timestamps
    end
  end
end
