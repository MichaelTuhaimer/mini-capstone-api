require "http"
require "tty-prompt"

prompt = TTY::Prompt.new
products = %w(Broom Mop Dustpan All)
product = prompt.select("Which product would you like to see?:", products)
if product == "Broom"
  product = "/products/1.json"
elsif product == "Mop"
  product = "/products/2.json"
elsif product == "Dustpan"
  product = "/products/3.json"
elsif product == "All"
  product = "/products.json"
end

response = HTTP.get("http://localhost:3000#{product}")
data = response.parse

puts data