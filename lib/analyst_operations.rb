module AnalystOperations

  def average(collection)
    if empty collection
      0
    elsif single collection
      single_operator(collection)
    else
      big collection
    end
  end

  def status_average_operator(status)
    matches = invoices.find_all do |invoice|
      invoice.id if invoice.status.eql?(status)
    end
    status_average_formatter(matches)
  end

  def status_average_formatter(matches)
    ((matches.size.to_f / invoices.size.to_f) * 100).to_s
  end

  def single_operator(collection)
    collection[0].to_f
  end

  def price_average_operator(id)
    average(price_compiler(id)).to_s
  end

  def average_average_operator
    averages = merchants.map do |merchant|
      average_item_price_for_merchant(merchant.id)
    end
    @average_average = decimal(average(averages).to_s).round(2)
  end

  def find_paid_invoices_from_merchant(id)
    invoices = sales_engine.invoices.find_all_by_merchant_id(id)
    invoice_id = invoices.map do |invoice|
      if invoice.is_paid_in_full?
        invoice.id
      end
    end.compact
  end

  def find_paid_items(id)
    paid_invoices = find_paid_invoices_from_merchant(id)
    paid_invoices.map do |item|
      invoice_items.find_all_by_invoice_id(item)
    end.flatten
  end

  def rank_invoice_items_by_quantity(id)
    paid_items = find_paid_items(id)
    sorted = paid_items.sort_by { |item| item.quantity }.reverse
    sorted.find_all {|item| item.quantity == sorted[0].quantity}
  end

  def rank_invoice_items_by_price(id)
    paid_items = find_paid_items(id)
    sorted = paid_items.sort_by { |item| item.unit_price }.reverse
  end

  def price_checker(merchant_id)
    ranked_items = rank_invoice_items_by_price(merchant_id)
    price_check = 0
    ranked_items.reduce([]) do |item_ids, item|
      if (item.unit_price) * (item.quantity) > price_check
        item_ids = item.item_id
        price_check += (item.unit_price) * (item.quantity)
        item_ids
      end
      item_ids
    end
  end

end