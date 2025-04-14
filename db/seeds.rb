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

# Tags (no more Tag.destroy_all)
[ "Best Sellers", "New Arrivals", "Discounts", "Great Value", "Our Top Pick" ].each do |tag_name|
  Tag.find_or_create_by!(name: tag_name)
end

# Sample Product + Tagging
category = Category.find_by(name: "Engine Parts")
tag = Tag.find_by(name: "Best Sellers")

if category && tag
  product = Product.find_or_create_by!(name: "Performance Air Filter") do |p|
    p.description = "Boost your engine performance with a reusable high-flow air filter."
    p.price = 59.99
    p.image_url = "https://via.placeholder.com/400"
    p.category = category
  end

  product.tags << tag unless product.tags.include?(tag)
end

# Admin User
User.find_or_create_by!(email: "itslindaycoding@gmail.com") do |user|
  user.password = "securepassword"
  user.first_name = "Lindsay"
  user.last_name = "Nicholson"
  user.role = :admin
end
