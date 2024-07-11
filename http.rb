require "http"
require "tty-prompt"

prompt = TTY::Prompt.new
# choice = prompt.select("Would you to view or create products?", %w(View Create))
products = %w(Broom Mop Dustpan Vacuum Soap All)
product = prompt.select("Which product would you like to see?:", products)
if product == "Broom"
  product = "/products/1.json"
elsif product == "Mop"
  product = "/products/2.json"
elsif product == "Dustpan"
  product = "/products/3.json"
elsif product == "Vacuum"
  product = "/products/4.json"
elsif product == "Soap"
  product = "/products/8.json"
elsif product == "All"
  product = "/products.json"
end

response1 = HTTP.get("http://localhost:3000#{product}")
data1 = response1.parse

# response2 = HTTP.post("http://localhost:3000/products?#{name}$#{price}$#{image_url}$#{description}.json")
# data2 =response2.parse

system "clear"
puts data1
