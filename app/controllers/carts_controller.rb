class CartsController < ApplicationController
  before_action :set_cart, only: %i[ show update destroy ]

  def index
    @carts = Cart.all

    render json: @carts
  end

  def show
    render json: @cart
  end

  def create
    @cart = Cart.new(cart_params)

    if @cart.save
      render json: @cart, status: :created, location: @cart
    else
      render json: @cart.errors, status: :unprocessable_entity
    end
  end

  def update
    if @cart.update(cart_params)
      render json: @cart
    else
      render json: @cart.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @cart.destroy!
  end

  def add_product
    cart = find_or_create_cart
    quantity = params[:quantity].to_i
    return render json: { error: 'Quantidade inválida' }, status: :unprocessable_entity if quantity <= 0

    cart.add_product(params[:product_id], quantity)
    render json: cart.payload
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :not_found
  end

  def show_current
    cart = session[:cart_id] ? Cart.includes(cart_items: :product).find_by(id: session[:cart_id]) : nil
  
    if cart
      render json: cart.payload
    else
      render json: { error: 'Carrinho não encontrado' }, status: :not_found
    end
  end

  def add_or_update_item
    cart = find_or_create_cart
    quantity = params[:quantity].to_i
    return render json: { error: 'Quantidade inválida' }, status: :unprocessable_entity if quantity <= 0

    cart.update_product_quantity(params[:product_id], quantity)
    render json: cart.payload
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :not_found
  end

  def remove_item
    cart = find_or_create_cart
    cart.remove_product(params[:product_id])
    render json: cart.payload
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :not_found
  end

  private

  def find_or_create_cart
    cart = session[:cart_id] && Cart.find_by(id: session[:cart_id])
    return cart if cart
  
    cart = Cart.create!(total_price: 0.0)
    session[:cart_id] = cart.id
    cart
  end

  def set_cart
    @cart = Cart.find(params[:id])
  end

  def cart_params
    params.require(:cart).permit(:name, :price)
  end
end
