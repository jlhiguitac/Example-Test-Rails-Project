class FindProducts
  attr_reader :products

  def initialize(products = initial_scope)
    @products = products
  end

  def call(params = {})
    scoped = products
    scoped = filter_by_category(scoped, params[:category_id]) if params[:category_id]
    scoped = filter_by_min_price(scoped, params[:min_price]) if params[:min_price]
    scoped = filter_by_max_price(scoped, params[:max_price]) if params[:max_price]
    scoped = filter_by_query_text(scoped, params[:query_text]) if params[:query_text]
    scoped = order_by(scoped, params[:order_by])
  end

  private
  def filter_by_category(scoped, category_id)
    return scoped unless category_id.present?
    scoped.where(category_id: category_id)
  end

  def filter_by_min_price(scoped, min_price)
    return scoped unless min_price.present?
    scoped.where("price >= ?", min_price)
  end

  def filter_by_max_price(scoped, max_price)
    return scoped unless max_price.present?
    scoped.where("price <= ?", max_price)
  end

  def filter_by_query_text(scoped, query_text)
    return scoped unless query_text.present?
    scoped.search_full_text(query_text)
  end

  def order_by(scoped, order_by_param)
    order_by = Product::ORDER_BY.fetch(order_by_param, Product::ORDER_BY["newest"])
    scoped.order(order_by)
  end

  def initial_scope
    Product.with_attached_photo
  end
end
