class Basket < ApplicationRecord
  belongs_to :user
  has_many :line_items
  has_many :products, through: :line_items

  def self.create_basket(user, num)
    gmail = Gmail.connect(:xoauth2, user.email, user.oauth_token)
    all_emails = gmail.inbox.emails(from: 'receipts@newseasonsmarket.com')
    num = num.to_i
    num = all_emails.length unless num.to_i <= all_emails.length
    wanted_emails = all_emails[all_emails.length - num..all_emails.length - 1]
    wanted_emails.each do |email|
      self.save_to_database(email, user) unless Basket.find_by(date: email.date)
    end
  end

  def self.save_to_database(email, user)
    binding.pry
    basket = user.baskets.create(date: DateTime.parse(email.date))
    binding.pry
    body = Nokogiri::HTML(email.body.decoded)
    wanted_rows = body.xpath(
      '//tr[td[(@class = "basket-item-qty") and normalize-space()]
      and td[(@class = "basket-item-desc") and normalize-space()]
      and td[(@class = "basket-item-amt") and normalize-space()]]'
    )
    wanted_rows.each do |r|
      quantity = r.css('.basket-item-qty').text.to_f
      quantity = 1 unless quantity.nonzero?
      description = r.css('.basket-item-desc').text.rstrip!.lstrip!
      price = r.css('.basket-item-amt').text.to_f * 100
      product = Product.find_or_create_by(name: description)
      basket.line_items.build(
        quantity: quantity,
        price_cents: price / quantity,
        product_id: product.id
      )
    end
    basket.save
  end

  def total
    amount = 0
    line_items.each { |li| amount += li.price * li.quantity }
    amount
  end
end
