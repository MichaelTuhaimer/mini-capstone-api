class ProductsController < ApplicationController
  def productid
    @product = Product.find_by(id: params[:id])
    render :show
  end

  def all_products
    @products = Product.all
    render :index
  end
end
