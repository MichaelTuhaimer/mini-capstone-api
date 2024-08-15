class OrdersController < ApplicationController
  before_action :authenticate_user

  def show
    @order = current_user.orders.find_by(id: params[:id])
    render :show
  end

  def index
    @orders = current_user.orders
    render :index
  end

  def create
    carted_products = CartedProduct.where(user_id: current_user.id, status: "carted")
    calc_subtotal = 0

    carted_products.each do |carted_product|
      product = Product.find_by(id: carted_product.product_id)
      price = product.price
      calc_subtotal += price * carted_product.quantity.to_i
    end

    calc_tax = calc_subtotal * 0.09
    calc_total = calc_subtotal + calc_tax

    @order = Order.create(
      user_id: current_user.id,
      subtotal: calc_subtotal,
      tax: calc_tax,
      total: calc_total,
    )
    carted_products.update_all(status: "purchased", order_id: @order.id)
    render :show
  end
end
