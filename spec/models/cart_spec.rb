require 'rails_helper'

RSpec.describe Cart, type: :model do
  let!(:cart) { create(:cart) }
  let!(:product) { create(:product) }

  context 'when validating' do
    before do
      cart.update_column(:total_price, -1)
    end

    it 'validates numericality of total_price' do
      cart = described_class.new(total_price: -1)
      expect(cart.valid?).to be_falsey
      expect(cart.errors[:total_price]).to include("must be greater than or equal to 0")
    end
  end

  describe 'MarkCartAsAbandonedJob' do
    context 'when cart is inactive for more than 3 hours' do
      let!(:cart) { create(:cart, :cart_with_4h_interaction) }

      it 'marks it as abandoned' do
        expect {
          MarkCartAsAbandonedJob.new.perform
          cart.reload
        }.to change { cart.cart_abandoned }.from(false).to(true)
      end
    end

    context 'when cart is abandoned for more than 7 days' do
      let!(:cart) { create(:cart, :abandoned) }

      before do
        cart.update_column(:updated_at, 8.days.ago)
      end

      it 'removes it from the database' do
        expect {
          MarkCartAsAbandonedJob.new.perform
        }.to change { Cart.exists?(cart.id) }.from(true).to(false)
      end
    end
  end

  describe '#remove_product' do
    let!(:cart_item) { create(:cart_item, cart: cart, product: product) }

    context 'when product is in the cart' do
      it 'removes the product from the cart and recalculates the total' do
        expect(cart.cart_items.count).to eq(1)

        expect {
          cart.remove_product(product.id)
        }.to change { cart.cart_items.count }.by(-1)

        expect(cart.total_price).to eq(0.0)
      end
    end
  end

  describe '#add_product' do
    context 'when product is not yet in the cart' do
      it 'adds a new cart item with the given quantity' do
        expect {
          cart.add_product(product.id, 1)
        }.to change { cart.cart_items.count }.by(1)

        cart_item = cart.cart_items.find_by(product_id: product.id)
        expect(cart_item).not_to be_nil
        expect(cart_item.quantity).to eq(2)
      end
    end
  end

  describe '#update_product_quantity' do
    let!(:cart_item) { create(:cart_item, cart: cart, product: product, quantity: 2) }

    context 'when product exists in the cart' do
      it 'updates the quantity of the product' do
        cart.update_product_quantity(product.id, 5)

        expect(cart_item.reload.quantity).to eq(5)
      end
    end
  end
end
