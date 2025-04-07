require "rails_helper"

RSpec.describe CartsController, type: :routing do
  describe 'routes' do
    it 'routes to #show_current' do
      expect(get: '/carts').to route_to('carts#show_current')
    end

    it 'routes to #add_product' do
      expect(post: '/carts').to route_to('carts#add_product')
    end

    it 'routes to #add_or_update_item' do
      expect(post: '/carts/add_items').to route_to('carts#add_or_update_item')
    end

    it 'routes to #remove_item' do
      expect(delete: '/carts/42').to route_to('carts#remove_item', product_id: '42')
    end
  end
end 
