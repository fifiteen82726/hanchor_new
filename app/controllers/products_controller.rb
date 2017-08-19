class ProductsController < ApplicationController
  before_action :get_cart_items

  add_breadcrumb "首頁", :root_path

  def index
    page_size = 9
    page_size = 100 if params[:all]

    @base_categories =  ProductCategory.where('parent_id is null')
    @base_category = ProductCategory.find_by(name_en: params[:category])
    select_ids = @base_category.child_category_ids << [@base_category.id]
    add_breadcrumb "產品 - #{@base_category.locale(params[:locale])}", products_index_path(params[:category])

    if params[:sub]
      @sub_category = ProductCategory.find_by(name_en: params[:sub])
      add_breadcrumb "產品 - #{@sub_category.locale(params[:locale])}", products_index_path(@base_category.name_en, sub: @sub_category.name_en)
    end
    if params[:sub]
      @products = Product.includes(:thumb).joins(:product_infos).where("product_infos.country_id = #{@country_id} and product_category_id = #{@sub_category.id}").visible.order_by_views_and_sort.select_info.paginate(:page => params[:page], :per_page => page_size)
    else
      @products = Product.includes(:thumb).joins(:product_infos).where("product_category_id in (#{select_ids.join(",")}) and product_infos.country_id = #{@country_id}").visible.order_by_views_and_sort.select_info.paginate(:page => params[:page], :per_page => page_size)
    end
  end

  def show
    @base_category = ProductCategory.find_by name_en: params[:category]
    @product = Product.includes(:product_category,:product_pics).joins(:product_infos).where("product_infos.country_id = #{@country_id}").all_info.find_by_slug(params[:id])
    @product = Product.includes(:product_category,:product_pics).joins(:product_infos).where("product_infos.country_id = #{@country_id}").all_info.find(params[:id]) unless @product
    @product.update_attribute("views",@product.views+1)
    @sub_category = @product.product_category
    @item = CartItem.new
    @product_size_selector = @product.size_selector(params[:locale])
    @product_color_selector = @product.color_selector(params[:locale])
    @related_products = Product.includes(:thumb).joins(:product_infos).select_info.where("product_infos.country_id = #{@country_id}").limit(4)
    add_breadcrumb "產品 - #{@base_category.locale(params[:locale])}", products_index_path(params[:category])
    add_breadcrumb @product.name, products_show_path(@product.product_category.name_en, @product)
  end

  def quantity
    @quantity = ProductQuantity.where(product_color_id: params[:color_id], product_size_id: params[:size_id])[0]
    @quantity_selector = @quantity.quantity_selector
  end

end