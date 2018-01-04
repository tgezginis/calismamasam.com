class ProductCategory < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  has_ancestry cache_depth: true

  has_many :products, foreign_key: 'category_id'

  validates :title, presence: true
  validates :title, uniqueness: true

  scope :has_product, -> { where('products_count > 0') }
  scope :has_post, -> do
    has_product.where(
      id: Product.joins(:posts).where('posts.id in (?)', Post.all.pluck(:id)).pluck(:category_id)
    )
  end
  scope :has_post_with_post_category, ->(post_category_id) do
    has_product.where(
      id: Product.joins(:posts).where('posts.id in (?)', Category.find_by(id: post_category_id).posts.active.pluck(:id)).pluck(:category_id)
    )
  end

  after_save do
    update_column(:path_cache, path.map(&:title).join(' » '))
  end

  def self.bottom_categories
    ProductCategory.where(id: ProductCategory.roots.map(&:child_ids).flatten.uniq)
  end

  def self.json_tree(nodes, active_id = nil, post_category_id = nil)
    nodes.map do |node|
      hash = {}
      hash['text'] = node.title
      hash['href'] = "/istatistikler/#{node.slug}"
      hash['nodes'] = ProductCategory.json_tree(node.children.has_product.has_post.order(title: :asc), active_id, post_category_id).compact if node.children.any?
      hash['state'] = {}
      hash['state']['selected'] = true if node.id == active_id
      hash.reject { |_k, v| v.nil? }
    end
  end

  def active_post_count
    products.map { |p| p.posts.active.count }.reduce(0, :+)
  end
end
