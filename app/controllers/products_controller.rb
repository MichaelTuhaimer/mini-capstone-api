class ProductsController < ApplicationController
  def one_product
    product = Product.find_by(id: 1)
    render json: { product: product }
  end

  def all_products
    products = Product.all
    render json: { products: products }
  end
end
