class AddOuIdToEntities < ActiveRecord::Migration
  def change
    add_column :entities, :ou_id, :integer, :default => nil
    add_index :entities, :ou_id
  end
end
