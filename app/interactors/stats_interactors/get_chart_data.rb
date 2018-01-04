module StatsInteractors
  class GetChartData
    include Interactor

    def call
      # Get products
      category_ids = context.parent_product_category ? context.parent_product_category.subtree.map(&:subtree_ids).flatten.uniq : nil
      products = Product.where(category_id: category_ids)
      if context.post_category.present?
        products = products.where(id: context.post_category.posts.active.map { |post| post.products.pluck(:product_id) }.flatten)
      end
      context.products = products

      # Set product ids
      context.product_ids = products.pluck(:id)

      # Group products by categories
      if products.any?
        records = ActiveRecord::Base.connection.execute(raw_query(products.pluck(:id).join(',')))
        total_records = ActiveRecord::Base.connection.execute(raw_query_for_total_count(products.pluck(:id).join(',')))
        total_count = total_records.class == Array ? total_records[0][0] : total_records.values[0][0]
      else
        records = []
        total_count = 0
      end

      # Set products for chart
      percentages = 0
      chart_array = records.map do |k|
        k = k.values.map(&:to_i)
        product = Product.find(k[1])
        next unless product
        percentage = ((k[0].to_f / total_count.to_f) * 100).round(2)
        next if percentage < 1.0
        percentages += percentage
        title = "#{product.decorate.name_with_brand} (#{percentage}%)"
        [title, k[0]]
      end
      chart_array = chart_array.compact
      sum_of_products = chart_array.inject(0) { |sum, x| sum + x[1] }
      if total_count.to_i > sum_of_products.to_i
        percentage = (100.00 - percentages).round(2)
        chart_array << ["Diğer (#{percentage})", total_count.to_i - sum_of_products.to_i]
      end
      context.chart_data = chart_array
    end


    private

    def raw_query(product_ids)
      %|
        SELECT COUNT(*) AS count_all, product_id
        FROM posts_products
        WHERE product_id in (#{product_ids})
        GROUP BY product_id
        ORDER BY count_all DESC, product_id;
      |
    end

    def raw_query_for_total_count(product_ids)
      %|
        SELECT COUNT(*)
        FROM posts_products
        WHERE product_id in (#{product_ids})
      |
    end
  end
end
