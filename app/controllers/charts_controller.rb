class ChartsController < ApplicationController

  before_action :set_baskets,  only: [:monthly_spending,
                                      :weekly_spending]
  before_action :set_products, only: [:most_spent, :most_bought]
  before_action :set_product,  only: [:product_monthly_purchasing,
                                      :product_weekly_purchasing]

  def monthly_spending
  end

  def weekly_spending
  end

  def most_spent
  end

  def most_bought
  end

  def product_monthly_purchasing
  end

  def product_weekly_purchasing
  end

  private

  def set_baskets
    @baskets = Basket.all
  end

  def set_product
    @product = Product.find(params[:product_id])
  end

  def set_products
    @products = Product.all
  end
end
