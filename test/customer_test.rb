require_relative 'test_helper'

class CustomerTest < Minitest::Test
    
  def setup
    @se = SalesEngine.from_csv({
      :items => "./data/items.csv",
      :invoices => "./fixtures/invoices_small_list.csv",
      :merchants => "./fixtures/merchant_small_list.csv",
      :invoice_items => "./fixtures/invoice_item_small_list.csv",
      :transactions => "./fixtures/transactions_small_list.csv",
      :customers => "./fixtures/customers_small_list.csv"
    })
    @cr = @se.customers
  end

  def test_it_knows_id
    assert_equal 1, @cr.all[0].id
    assert_equal 4, @cr.all[3].id
  end

  def test_it_knows_customer_name
    assert_equal "Leanne", @cr.all[3].first_name
    assert_equal "Braun", @cr.all[3].last_name
  end

  def test_it_determines_time
    assert_equal "2012-03-27 14:54:09 UTC", @cr.all[0].created_at.to_s
    assert_equal "2012-03-27 14:54:09 UTC", @cr.all[0].updated_at.to_s
  end

  def test_it_knows_parent
    assert_equal CustomerRepository, @cr.all[0].customer_parent.class
  end

  def test_it_knows_its_associated_merchants
    assert_equal Array, @cr.all[0].merchants.class
    assert_equal Merchant, @cr.all[0].merchants[1].class
  end
end