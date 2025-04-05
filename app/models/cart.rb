class Cart < ApplicationRecord
  has_many :cart_items, dependent: :destroy

  validates_numericality_of :total_price, greater_than_or_equal_to: 0

  def remove_product(product_id)
    item = cart_items.find_by(product_id: product_id)

    raise ActiveRecord::RecordNotFound, "Produto não encontrado no carrinho" unless item

    item.destroy
    recalculate_total!
  end

  def add_product(product_id, quantity)
    item = cart_items.find_or_initialize_by(product_id: product_id)
    item.quantity += quantity.to_i
    item.save!

    recalculate_total!
  end

  def update_product_quantity(product_id, quantity)
    item = cart_items.find_by(product_id: product_id)
    raise ActiveRecord::RecordNotFound, "Produto não encontrado no carrinho" unless item

    item.update!(quantity: quantity)
    recalculate_total!
  end

  def recalculate_total!
    total = cart_items.includes(:product).sum { |item| item.quantity * item.product.price }
    update!(total_price: total)
  end

  def payload
    {
      id: id,
      products: cart_items.includes(:product).map do |item|
        {
          id: item.product.id,
          name: item.product.name,
          quantity: item.quantity,
          unit_price: item.product.price.to_f,
          total_price: (item.quantity * item.product.price).to_f
        }
      end,
      total_price: total_price.to_f
    }
  end
end
