require 'rails_helper'

RSpec.describe "/carts", type: :request do
  describe "POST /add_items" do
    let!(:cart) { create(:cart) }
    let!(:product) { create(:product) }
    let!(:cart_item) { create(:cart_item, cart: cart, product: product) }

    context 'when the product already is in the cart' do
      subject do
        post '/add_items', params: { product_id: product.id, quantity: 1 }, as: :json
        post '/add_items', params: { product_id: product.id, quantity: 1 }, as: :json
      end

      it 'updates the quantity of the existing item in the cart' do
        expect { subject }.to change { cart_item.reload.quantity }.by(2)
      end
    end
  end
end
