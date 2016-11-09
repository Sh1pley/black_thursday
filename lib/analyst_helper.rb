module AnalystHelper

  def decimal(number)
    BigDecimal.new(number)
  end

  def format(number)
    number.round(2).to_f
  end
  
  def price_compiler(id)
    merchant_items = sales_engine.find_all_items_by_merchant_id(id)
    no_prices                  if merchant_items.size == 0
    all_prices(merchant_items) if merchant_items.size > 0
  end

  def no_prices
    prices = [0]
  end

  def all_prices(merchant_items)
    merchant_items.map { |item| item.unit_price }
  end

  def empty(collection)
    collection == nil
  end

  def single(collection)
    collection.size == 1
  end

  def big(collection)
    collection.reduce(&:+).to_f / collection.size.to_f
  end

  # def successful_transactions
  #   transactions.find_all do |transaction|
  #     transaction.result.eql?("success")
  #   end
  # end

  # def successful_invoices
  #   invoice_ids = successful_transactions.map { |transaction| transaction.invoice_id }
  #   invoice_ids.map { |invoice_id| sales_engine.invoices.find_by_id(invoice_id) }
  # end

  def merchant_name(id)
    merchant = sales_engine.invoices.find_by_id(id).merchant_id
    sales_engine.merchants.find_by_id(merchant).name
  end

  def hash_maker
    invoices.each do |invoice|
      invoice_total = invoice.total
      @merchant_revenue[invoice.merchant_id] += invoice_total
    end
  end
    
  def days_of_the_week
    days = Hash.new(0)
    @invoices.each do |invoice|
      days["Sunday"]    += 1 if invoice.created_at.sunday?
      days["Monday"]    += 1 if invoice.created_at.monday?
      days["Tuesday"]   += 1 if invoice.created_at.tuesday?
      days["Wednesday"] += 1 if invoice.created_at.wednesday?
      days["Thursday"]  += 1 if invoice.created_at.thursday?
      days["Friday"]    += 1 if invoice.created_at.friday?
      days["Saturday"]  += 1 if invoice.created_at.saturday?
    end
    days
  end

  def merchant_month(merchant)
    if merchant.created_at[5..6] == "01"
      "january"
    elsif merchant.created_at[5..6] == "02"
      "february"
    elsif merchant.created_at[5..6] == "03"
      "march"
    elsif merchant.created_at[5..6] == "04"
      "april"
    elsif merchant.created_at[5..6] == "05"
      "may"
    elsif merchant.created_at[5..6] == "06"
      "june"
    elsif merchant.created_at[5..6] == "07"
      "july"
    elsif merchant.created_at[5..6] == "08"
      "august"
    elsif merchant.created_at[5..6] == "09"
      "september"
    elsif merchant.created_at[5..6] == "10"
      "october"
    elsif merchant.created_at[5..6] == "11"
      "november"
    elsif merchant.created_at[5..6] == "12"
      "december"
    end
  end
  
end

