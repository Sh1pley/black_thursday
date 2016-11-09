require_relative 'test_helper'

class TransactionTest < Minitest::Test

   def setup
    @se = SalesEngine.from_csv({
      :items => "./data/items.csv",
      :invoices => "./fixtures/invoices_small_list.csv",
      :merchants => "./fixtures/merchant_small_list.csv",
      :invoice_items => "./fixtures/invoice_item_small_list.csv",
      :transactions => "./fixtures/transactions_small_list.csv",
      :customers => "./fixtures/customers_small_list.csv"
    })
    @tr = @se.transactions
  end

  def test_it_knows_id
    assert_equal 1, @tr.all[0].id
    assert_equal 4, @tr.all[3].id
  end

  def test_it_knows_transaction_id
    assert_equal 1, @tr.all[0].id
    assert_equal 4, @tr.all[3].id
  end

  def test_it_knows_invoice_id
    assert_equal 2179, @tr.all[0].invoice_id
    assert_equal 4126, @tr.all[3].invoice_id
  end

  def test_it_knows_the_cc_number
    assert_equal 4068631943231473, @tr.all[0].credit_card_number
    assert_equal "0217", @tr.all[0].credit_card_expiration_date
  end

  def test_ids_have_correct_format
    assert_equal Fixnum, @tr.all[0].credit_card_number.class
    assert_equal String, @tr.all[0].credit_card_expiration_date.class
    assert_equal Fixnum, @tr.all[0].invoice_id.class
    assert_equal Fixnum, @tr.all[0].id.class
  end

  def test_it_knows_transaction_result
    assert_equal "success", @tr.all[0].result
    refute_equal "success", @tr.all[8].result
  end

  def test_it_determines_time
    assert_equal "2012-02-26 20:56:56 UTC", @tr.all[0].created_at.to_s
    assert_equal "2012-02-26 20:56:56 UTC", @tr.all[0].updated_at.to_s
  end

  def test_it_knows_parent
    assert_equal TransactionRepository, @tr.all[0].transaction_parent.class
  end
end