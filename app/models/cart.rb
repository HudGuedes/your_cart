class Cart < ApplicationRecord
  has_many :cart_items, dependent: :destroy

  validates_numericality_of :total_price, greater_than_or_equal_to: 0

  scope :active, -> { where(cart_abandoned: false) }
  scope :cart_abandoned_for_more_than_7_days, -> { where(cart_abandoned: true).where('updated_at < ?', 7.days.ago) }
  scope :cart_inactive_for_more_than_3_hours, -> { where('last_interaction_at < ? AND cart_abandoned = ?', 3.hours.ago, false) }

  before_create :set_last_interaction
  before_save :check_items_quantities

  def set_last_interaction
    self.last_interaction_at ||= Time.current
  end

  def cart_interaction
    update!(last_interaction_at: Time.current) unless cart_abandoned?
  end

  def remove_product(product_id)
    item = cart_items.find_by(product_id: product_id)

    raise ActiveRecord::RecordNotFound, "Produto não encontrado no carrinho" unless item

    item.destroy
    recalculate_total
    cart_interaction
  end

  def add_product(product_id, quantity)
    product = Product.find(product_id)
    item = cart_items.find_or_initialize_by(product_id: product_id)
    item.quantity += quantity.to_i
    item.save!

    recalculate_total
    cart_interaction
  end

  def update_product_quantity(product_id, quantity)
    item = cart_items.find_by(product_id: product_id)
    raise ActiveRecord::RecordNotFound, "Produto não encontrado no carrinho" unless item

    item.update!(quantity: quantity)
    recalculate_total
    cart_interaction
  end

  def recalculate_total
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

  def check_items_quantities
    if cart_items.any? { |item| item.quantity <= 0 }
      errors.add(:base, 'Quantidade deve ser maior do que zero!')
      throw(:abort)
    end
  end
end
