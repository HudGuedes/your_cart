require 'rails_helper'

RSpec.describe CartItem, type: :model do
  describe 'associations' do
    it { should belong_to(:cart) }
    it { should belong_to(:product) }
  end

  describe 'validations' do
    it { should validate_numericality_of(:quantity).is_greater_than(0) }
  end

  describe 'factory' do
    let!(:cart_item) { build(:cart_item) }
    let!(:cart_item_zero) { build(:cart_item, :quantity_zero) }
    let!(:cart_item_negative) { build(:cart_item, :quantity_negative) }

    it 'is invalid with quantity 0 or less' do
      expect(cart_item).to be_valid
      expect(cart_item_zero).not_to be_valid
      expect(cart_item_negative).not_to be_valid
    end
  end
end
