# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Categories
[
  "Brakes",
  "Suspension",
  "Lighting",
  "Engine Parts",
  "Electronics",
  "Detailing",
  "Accessories"
].each do |category_name|
  Category.find_or_create_by!(name: category_name)
end

# Tags
Tag.destroy_all
Tag.create!([
  { name: "Best Sellers" },
  { name: "New Arrivals" },
  { name: "Discounts" },
  { name: "Great Value" },
  { name: "Our Top Pick" }
])


category = Category.find_by(name: "Engine Parts")
tag = Tag.find_by(name: "Best Sellers")

product = Product.create!(
  name: "Performance Air Filter",
  description: "Boost your engine performance with a reusable high-flow air filter.",
  price: 59.99,
  image_url: "https://via.placeholder.com/400",
  category: category
)

product.tags << tag

User.find_or_create_by!(email: "itslindaycoding@gmail.com") do |user|
  user.password = "securepassword"
  user.first_name = "Lindsay"
  user.last_name = "Nicholson"
  user.role = :admin
end
