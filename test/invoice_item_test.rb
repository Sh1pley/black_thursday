require_relative 'test_helper'

class InvoiceItemTest < Minitest::Test

   def setup
    @se = SalesEngine.from_csv({
      :items => "./data/items.csv",
      :invoices => "./fixtures/invoices_small_list.csv",
      :merchants => "./fixtures/merchant_small_list.csv",
      :invoice_items => "./fixtures/invoice_item_small_list.csv",
      :transactions => "./fixtures/transactions_small_list.csv",
      :customers => "./fixtures/customers_small_list.csv"
    })
    @iir = @se.invoice_items
  end

  def test_it_knows_id
    assert_equal 1, @iir.all[0].id
    assert_equal 4, @iir.all[3].id
  end

  def test_it_knows_item_id
    assert_equal 263519844, @iir.all[0].item_id
    assert_equal 263542298, @iir.all[3].item_id
  end

  def test_it_knows_invoice_id
    assert_equal 1, @iir.all[0].invoice_id
    assert_equal 1, @iir.all[3].invoice_id
  end

  def test_ids_have_correct_format
    assert_equal Fixnum, @iir.all[0].item_id.class
    assert_equal Fixnum, @iir.all[0].invoice_id.class
    assert_equal Fixnum, @iir.all[0].id.class
  end

  def test_it_knows_quantity
    assert_equal 5, @iir.all[0].quantity
    assert_equal 3, @iir.all[3].quantity
  end

  def test_it_knows_unit_price_as_big_decimal
    assert_equal BigDecimal, @iir.all[0].unit_price.class
  end

  def test_it_determines_time
    assert_equal "2012-03-27 14:54:09 UTC", @iir.all[0].created_at.to_s
    assert_equal "2012-03-27 14:54:09 UTC", @iir.all[0].updated_at.to_s
  end

  def test_it_knows_parent
    assert_equal InvoiceItemRepository, @iir.all[0].invoice_parent.class
  end
end