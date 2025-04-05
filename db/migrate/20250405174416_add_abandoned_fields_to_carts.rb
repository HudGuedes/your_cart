class AddAbandonedFieldsToCarts < ActiveRecord::Migration[7.1]
  def change
    add_column :carts, :cart_abandoned, :boolean, default: false, null: false
    add_column :carts, :last_interaction_at, :datetime
  end
end
