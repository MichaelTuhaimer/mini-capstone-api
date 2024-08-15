class CartedProductsController < ApplicationController
  def index
    @carted_products = CartedProduct.where(user_id: current_user.id, status: "carted")
    render :index
  end

  def create
    @carted_product = CartedProduct.create(
      user_id: current_user.id,
      product_id: params[:product_id],
      quantity: params[:quantity],
      status: "carted",
      order_id: nil,
    )
    render :show
  end

  def destroy
    carted_product = current_user.carted_products.find_by(id: params[:id])
    carted_product.update(status: "removed")
    render json: { message: "Carted product removed successfully." }
  end
end
