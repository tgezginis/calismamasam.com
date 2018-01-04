module StatsInteractors
  class GetProductChartData
    include Interactor

    def call
      context.fail!(error: 'Product not found') unless context.product.present?
      product = context.product

      records = ActiveRecord::Base.connection.execute(raw_query(product.id))
      total_records = ActiveRecord::Base.connection.execute(raw_query_for_total_count(product.id))
      total_count = total_records.class == Array ? total_records[0][0] : total_records.values[0][0]

      # Set categories for chart
      percentages = 0
      chart_array = records.map do |k|
        k = k.values.map(&:to_i)
        category = Category.find(k[1])
        next unless category
        percentage = ((k[0].to_f / total_count.to_f) * 100).round(2)
        next if percentage < 1.0
        percentages += percentage
        title = "#{category.title} (#{percentage}%)"
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

    def raw_query(product_id)
      %|
        SELECT COUNT(categories_posts.category_id) AS count_all, categories_posts.category_id
        FROM posts_products
        INNER JOIN categories_posts ON posts_products.post_id = categories_posts.post_id
        WHERE posts_products.product_id = #{product_id}
        GROUP BY posts_products.product_id, categories_posts.category_id
        ORDER BY count_all DESC;
      |
    end

    def raw_query_for_total_count(product_id)
      %|
        SELECT COUNT(categories_posts.category_id)
        FROM posts_products
        LEFT JOIN categories_posts ON posts_products.post_id = categories_posts.post_id
        WHERE posts_products.product_id = #{product_id};
      |
    end
  end
end
