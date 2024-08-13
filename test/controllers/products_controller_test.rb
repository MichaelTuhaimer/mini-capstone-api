require "test_helper"

class ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create(name: "Test", email: "test@test.com", password: "password", admin: true)
    post "/sessions.json", params: { email: "test@test.com", password: "password" }
    data = JSON.parse(response.body)
    @jwt = data["jwt"]
  end

  test "index" do
    get "/products.json"
    assert_response 200

    data = JSON.parse(response.body)
    assert_equal Product.count, data.length
  end

  test "show" do
    get "/products/#{Product.first.id}.json"
    assert_response 200

    data = JSON.parse(response.body)
    assert_equal ["id", "name", "price", "supplier", "tax", "total", "is_discounted?", "images", "categories", "description", "created_at", "updated_at"].sort, data.keys.sort
  end

  test "create" do
    assert_difference "Product.count", 1 do
      post "/products.json",
        params: { name: "test", price: 10, image_url: "test.jpg", description: "test description", supplier_id: Supplier.first.id },
        headers: { "Authorization" => "Bearer #{@jwt}" }
      assert_response 200
    end

    assert_difference "Product.count", 0 do
      post "/products.json",
        params: {},
        headers: { "Authorization" => "Bearer #{@jwt}" }
      assert_response 422
    end

    post "/products.json", params: {}
    assert_response 401
  end

  test "update" do
    product = Product.first
    patch "/products/#{product.id}.json",
      params: { name: "Updated name" },
      headers: { "Authorization" => "Bearer #{@jwt}" }
    assert_response 200

    data = JSON.parse(response.body)
    assert_equal "Updated name", data["name"]
    assert_equal product.price.to_s, data["price"]
    assert_equal product.description, data["description"]

    patch "/products/#{product.id}.json",
      params: { name: "" },
      headers: { "Authorization" => "Bearer #{@jwt}" }
    assert_response 422

    patch "/products/#{product.id}.json"
    assert_response 401
  end

  test "destroy" do
    assert_difference "Product.count", -1 do
      delete "/products/#{Product.first.id}.json", headers: { "Authorization" => "Bearer #{@jwt}" }
      assert_response 200
    end

    delete "/products/#{Product.first.id}.json"
    assert_response 401
  end

  test "is_discounted?" do
    product = Product.new(price: 11)
    assert_equal false, product.is_discounted?

    product = Product.new(price: 1)
    assert_equal true, product.is_discounted?
  end

  test "tax" do
    product = Product.new(price: 100)
    assert_in_delta 9, product.tax
  end

  test "total" do
    product = Product.new(price: 100)
    assert_in_delta 109, product.total
  end
end
