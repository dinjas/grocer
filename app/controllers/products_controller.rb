class ProductsController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_action :set_variables, only: [:show, :update]

  def index
    if current_user
      @products = current_user.products.filtered_products
      .custom_sort(sort_column, sort_direction).page params[:page]
      respond_to do |format|
        format.js
        format.html
      end
    end
  end

  def show
    if !@user.products.include?(@product)
      redirect_to products_path,
      flash: { alert: I18n.t('products.must_own') }

    end
    respond_to do |format|
      format.js
      format.html
    end
  end

  def create; end

  def update
    @product.update(nickname: params[:product][:nickname])
  end

  private

  def set_variables
    @user = current_user
    @product = Product.find(params[:id])
    @line_items = @product.this_users_line_items(@user)
                          .custom_sort(sort_column, sort_direction)
                          .page params[:page]
  end

  def sort_column
    params[:sort]
  end

  def sort_direction
    %w(asc desc).include?(params[:direction]) ? params[:direction] : 'asc'
  end
end
