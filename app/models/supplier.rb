class Supplier < ApplicationRecord
  def products
    Product.where(supplier_id: self.id)
  end
end
