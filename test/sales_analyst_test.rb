require_relative 'test_helper'
require './lib/standard_deviation'
require './lib/analyst_helper'
require './lib/analyst_operations'

class SalesAnalystTest < Minitest::Test
  include StandardDeviation
  include AnalystHelper
  include AnalystOperations

  def setup
    @se = SalesEngine.from_csv({
      :items => "./fixtures/items_small_list.csv",
      :invoices => "./fixtures/invoices_small_list.csv",
      :merchants => "./fixtures/merchant_small_list.csv",
      :invoice_items => "./fixtures/invoice_item_small_list.csv",
      :transactions => "./fixtures/transactions_small_list.csv",
      :customers => "./fixtures/customers_small_list.csv"
    })
    @sa = SalesAnalyst.new(@se)
  end

  def test_it_exists
    assert @sa
  end

  def test_it_knows_parent
    refute @sa.sales_engine.nil?
  end

  def test_it_can_find_the_standard_deviation
    result = @sa.average_items_per_merchant_standard_deviation
  end

  def test_it_calculates_average_per_standard_deviation
    assert_equal 0.34, @sa.average_items_per_merchant_standard_deviation
  end

  def test_it_calculates_average_items_per_merchant
    assert_equal 0.06, @sa.average_items_per_merchant
  end

  def test_it_can_calculate_average_item_price
    assert_equal 29.99, @sa.average_item_price_for_merchant(12334105).to_f
  end

  def test_it_calculates_average_average_price
    assert_equal 2.04, @sa.average_average_price_per_merchant.to_f
  end

  def test_average_method_averages
    assert_equal 2, @sa.average([1,2,3])
  end

  def test_it_can_find_merchants_with_high_item_count
    assert_equal Merchant, @sa.merchants_with_high_item_count[0].class
  end

  def test_it_can_find_golden_items
    assert_equal Item, @sa.golden_items[0].class
  end

  def test_it_can_locate_merchants_with_only_one_item
    assert_equal Array, @sa.merchants_with_only_one_item.class
    assert_equal Merchant, @sa.merchants_with_only_one_item[0].class
  end

  def test_it_can_locate_merchants_with_pending_invoices
    assert_equal Array, @sa.merchants_with_pending_invoices.class
    assert_equal Merchant, @sa.merchants_with_pending_invoices[0].class
  end

def test_it_can_find_most_sold_items
      engine = SalesEngine.from_csv({
        :items => "./data/items.csv",
        :invoices => "./data/invoices.csv",
        :merchants => "./data/merchants.csv",
        :invoice_items => "./data/invoice_items.csv",
        :transactions => "./data/transactions.csv",
        :customers => "./data/customers.csv"
      })
    san = SalesAnalyst.new(engine)
    
    assert_equal Array, san.most_sold_item_for_merchant(san.merchants[3].id).class
    assert_equal Item, san.most_sold_item_for_merchant(san.merchants[3].id)[0].class
  end

  def test_it_can_best_item_for_merchant
    engine = SalesEngine.from_csv({
      :items => "./data/items.csv",
      :invoices => "./data/invoices.csv",
      :merchants => "./data/merchants.csv",
      :invoice_items => "./data/invoice_items.csv",
      :transactions => "./data/transactions.csv",
      :customers => "./data/customers.csv"
    })
    san = SalesAnalyst.new(engine)
    
    assert_equal Item, san.best_item_for_merchant(san.merchants[0].id).class
  end

  def test_for_top_revenue_earners
    engine = SalesEngine.from_csv({
      :items => "./data/items.csv",
      :invoices => "./data/invoices.csv",
      :merchants => "./data/merchants.csv",
      :invoice_items => "./data/invoice_items.csv",
      :transactions => "./data/transactions.csv",
      :customers => "./data/customers.csv"
    })
    san = SalesAnalyst.new(engine)

    assert_equal Array, san.top_revenue_earners.class
    assert_equal Merchant, san.top_revenue_earners[0].class
  end
end