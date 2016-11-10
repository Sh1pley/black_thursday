require_relative 'sales_engine'
require_relative 'standard_deviation'
require_relative 'analyst_helper'
require_relative 'analyst_operations'

class SalesAnalyst
  include StandardDeviation
  include AnalystHelper
  include AnalystOperations

  attr_reader   :sales_engine,    :invoices,
                :transactions,    :merchants,
                :items,           :invoice_items

  def initialize(sales_engine)
    @sales_engine         = sales_engine
    @merchants            = sales_engine.merchants.all
    @invoices             = sales_engine.invoices.all
    @items                = sales_engine.items.all
    @transactions         = sales_engine.transactions.all
    @invoice_items        = sales_engine.invoice_items
    @item_prices          = items.map { |item| item.unit_price }
    @item_counts          = merchants.map { |merchant| merchant.items.size }
    @invoice_counts       = merchants.map { |merchant| merchant.invoices.size }
    @merchant_revenue     = Hash.new(decimal 0)
  end

  def average_items_per_merchant
    format decimal average(@item_counts).to_s
  end

  def average_invoices_per_merchant
    format decimal average(@invoice_counts).to_s
  end

  def average_item_price_for_merchant(id)
    decimal(price_average_operator(id)).round(2)
  end

  def average_average_price_per_merchant
    average_average_operator
  end

  def invoice_status(status)
    format decimal status_average_operator(status)
  end

  def average_items_per_merchant_standard_deviation
    format decimal standard_deviation(@item_counts).to_s
  end

  def average_invoices_per_merchant_standard_deviation
    format decimal standard_deviation(@invoice_counts).to_s
  end

  def merchants_with_high_item_count
    one_deviation_above = item_number_plus_one_deviation
    merchants.find_all do |merchant|
      merchant.items.count >= one_deviation_above
    end
  end

  def top_days_by_invoice_count
    one_deviation_above = one_standard_deviation_above_mean_for_weekdays
    days_of_the_week.each_pair.map do |day, invoice_count|
      day if invoice_count > one_deviation_above
    end.compact
  end

  def top_merchants_by_invoice_count
    one_deviation_above = one_standard_deviation_above_invoice_average
    merchant_list       = merchants.find_all do |merchant|
      merchant.invoices.size >= one_deviation_above
    end
  merchant_list.flatten
  end

  def bottom_merchants_by_invoice_count
    one_deviation_below = one_standard_deviation_below_invoice_average
    merchants.find_all do |merchant|
      merchant.invoices.size <= one_deviation_below
    end
  end

  def golden_items
    two_deviations_above = two_standard_deviations_away_in_price
    items.find_all do |item|
      item.unit_price >= two_deviations_above
    end
  end

  def revenue_by_merchant(id)
    @merchant_revenue[id]
  end

  def merchants_with_only_one_item
    merchants.find_all do |merchant|
      merchant.items.count == 1
    end
  end

  def merchants_with_only_one_item_registered_in_month(input_month)
    results = []
    merchants_with_only_one_item.each do |merchant|
      if merchant_month(merchant) == input_month.downcase
        results << merchant
      else
        nil
      end
    end
    results.compact
  end

  def merchants_with_pending_invoices
      results = pending_invoices.map do |invoice|
      sales_engine.merchants.find_by_id(invoice.merchant_id)
    end
    results.uniq
  end

  def most_sold_item_for_merchant(merchant_id)
    ranked_items = rank_invoice_items_by_quantity(merchant_id)
    ranked_items.map { |item| sales_engine.items.find_by_id(item.item_id) }
  end

  def best_item_for_merchant(merchant_id)
    top_item = price_checker(merchant_id)
    sales_engine.items.find_by_id(top_item)
  end

  def merchants_ranked_by_revenue
    ranked_merchants = merchant_revenues.map do |merchant|
      sales_engine.merchants.find_by_id(merchant[0])
    end
  end

  def top_revenue_earners(select = 20)
      merchants_ranked_by_revenue.take(select)
  end

  def total_revenue_by_date(date)
    sales_engine.invoices.find_all_by_date(date).reduce(0) do |revenue, invoice|
      revenue += invoice.total
      revenue
    end
  end

end
