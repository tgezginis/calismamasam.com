# Create an administrator
User.create!(name: 'Admin', email: 'admin@admin.com', password: 'password', password_confirmation: 'password', role: :admin)

# Create a product and dependencies
category = Category.create!(title: 'Software Developer')
product_category = ProductCategory.create!(title: 'Bilgisayar', parent: ProductCategory.create!(title: 'Donanım'))
product_brand = ProductBrand.create!(name: 'Apple')
product = Product.create!(category: product_category, brand: product_brand, name: 'Macbook Pro')

# Create a post and dependencies
3.times do
  post = Post.create!(
    is_active: true,
    title: Faker::Name.name,
    job_title: 'Software Developer',
    company: Faker::Company.name,
    twitter_url: 'https://twitter.com/calismamasamcom',
    body: Faker::Lorem.paragraphs(20),
    description: Faker::Lorem.paragraph,
    published_at: Time.current
  )
  post.categories << category
  post.products << product
end
