require 'rails_helper'

describe Product do

  it 'has a valid factory' do
    expect(build(:product)).to be_valid
  end

  it 'is invalid without a name' do
    product = build(:product, name: nil)
    product.valid?

    expect(product.errors[:name]).to include("can't be blank")
  end

  let(:user) { create(:user) }
  let(:user_two) { create(:user) }
  let(:product_one) { create(:product) }
  let(:product_two) { create(:product) }
  let(:basket_one) do
    create(:basket,
           date: '2016-01-01',
           user_id: user.id)
  end
  let(:basket_two) do
    create(:basket,
           date: '2016-01-01',
           user_id: user.id)
  end
  let(:basket_three) do
    create(:basket,
           date: '2016-01-01',
           user_id: user_two.id)
  end
  let!(:line_item_one) do
    create(:line_item,
           basket_id: basket_one.id,
           quantity: 1,
           price_cents: 900,
           total_cents: 900,
           product_id: product_one.id)
  end
  let!(:line_item_two) do
    create(:line_item,
           basket_id: basket_two.id,
           quantity: 5,
           price_cents: 300,
           total_cents: 1500,
           product_id: product_one.id)
  end
  let!(:line_item_three) do
    create(:line_item,
           basket_id: basket_three.id,
           quantity: 1,
           price_cents: 600,
           total_cents: 600,
           product_id: product_one.id)
  end
  let!(:line_item_four) do
    create(:line_item,
           basket_id: basket_three.id,
           quantity: 3,
           price_cents: 400,
           total_cents: 1200,
           product_id: product_two.id)
  end
  # let!(:line_item_five) do
  #   create(:line_item,
  #          basket_id: basket_one.id,
  #          product_id: product_one.id,
  #          quantity: 20,
  #          price_cents: 500,
  #          total_cents: 10000)
  # end

  #before(:each) do
  #  user.reload
  #  user_two.reload
  #  product_one.reload
  #  product_two.reload
  #end

  describe '#times_bought' do
    it 'returns number of times user has purchased' do
      expect(product_one.times_bought(user)).to eq 6
      expect(product_two.times_bought(user)).to eq 20
    end
  end

  describe '#highest_price' do
    it 'returns highest price product has sold for' do
      expect(product_one.highest_price).to eq Money.new(900)
    end
  end

  describe '#lowest_price' do
    it 'returns the lowest price product has sold for' do
      expect(product_one.lowest_price).to eq Money.new(300)
    end
  end


  describe '.most_popular_product' do
    it 'knows the most popular product' do
      expect(Product.most_popular_product).to eq product_two
    end
  end

  it 'knows the most expensive product' do
    expect(Product.most_expensive_product).to eq product_one
  end

  it 'knows the most expensive product by user' do
    expect(Product.most_expensive_product_by_user(user)).to eq product_one
    expect(Product.most_expensive_product_by_user(user_two)).to eq product_one

  end

  it 'knows the least expensive product' do
    expect(Product.least_expensive_product).to eq product_one
  end

  it 'knows the least expensive product by user' do
    expect(Product.least_expensive_product_by_user(user)).to eq product_one
    expect(Product.least_expensive_product_by_user(user_two)).to eq product_two
  end
end
