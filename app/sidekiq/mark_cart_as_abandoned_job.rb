class MarkCartAsAbandonedJob
  include Sidekiq::Job

  def perform(*args)
    Cart.cart_inactive_for_more_than_3_hours.find_each do |cart|
      cart.update!(cart_abandoned: true)
      Rails.logger.info "Carrinho de id: #{cart.id} marcado como abandonado"
    end

    Cart.cart_abandoned_for_more_than_7_days.find_each do |cart|
      cart.destroy!
      Rails.logger.info "Carrinho de id: #{cart.id} foi removido por estar abandonado há mais de 7 dias"
    end
  end
end
