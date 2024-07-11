class ProductsController < ApplicationController
  def productid
    @product = Product.find_by(id: params[:id])
    render :show
  end

  def all_products
    @products = Product.all
    render :index
  end

  def create_product
    @product = Product.create(
      name: params[:name],
      price: params[:price],
      image_url: params[:image_url],
      description: params[:description],
    )
    render :show
  end
end
