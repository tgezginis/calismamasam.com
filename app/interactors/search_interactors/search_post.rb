module SearchInteractors
  class SearchPost
    include Interactor

    def call
      @params = context.params
      @query = context.query
      @per_page = context.per_page || 20
      @page = context.page || 0
      return_error('Aranan kelime boş bırakılamaz') if @query.blank?
      @posts = Post.search(@query, search_parameters)
      @facets = @posts.facets
      set_facets
      response_message
    end

    private

    def search_parameters
      {
        facets: %w[categories company products],
        facetFilters: facet_filters,
        maxValuesPerFacet: 20,
        hitsPerPage: @per_page,
        page: @page
      }
    end

    def facet_filters
      filters = []
      filters << "categories:#{@params[:category]}" unless @params[:category].blank?
      filters << "company:#{@params[:company]}" unless @params[:company].blank?
      filters << "product:#{@params[:product]}" unless @params[:product].blank?
      filters
    end

    def set_facets
      @facets.keys.each do |k|
        @facets['Kategoriler'] = @facets.delete(k) if k == 'categories'
        @facets['Kullandığı Ürünler'] = @facets.delete(k) if k == 'products'
        @facets['Çalıştığı Şirket'] = @facets.delete(k) if k == 'company'
      end
      @facets = @facets.sort_by { |k, _v| k }
    end

    def return_error(message)
      context.error = message
      context.fail!
      false
    end

    def response_message
      context.posts = @posts
      context.posts_count = @posts.count || 0
      context.total_pages = @posts.total_pages || 1
      context.facets = @facets
    end
  end
end
