require_relative 'invoice_repository'
require 'pry'

class Invoice
  attr_reader   :id,
                :customer_id,
                :merchant_id,
                :status,
                :created_at,
                :updated_at,
                :invoice_parent

  def initialize(invoice_data, parent = nil)
    @invoice_parent = parent
    @id             = invoice_data[:id].to_i
    @customer_id    = invoice_data[:customer_id].to_i
    @merchant_id    = invoice_data[:merchant_id].to_i
    @status         = invoice_data[:status].to_sym
    @created_at  = determine_the_time(invoice_data[:created_at])
    @updated_at  = determine_the_time(invoice_data[:updated_at])
  end

  def merchant
    invoice_parent.parent.merchants.find_by_id(@merchant_id)
  end

  def items
    id = invoice_parent.parent.items.find_all_by_merchant_id(@merchant_id)
    result = id.map do |item|
      invoice_parent.parent.items.find_by_id(item.id)
    end
    result
  end

  def invoice_items
    ids = items.map { |item| item.id }
    ids.map { |id| invoice_parent.parent.invoice_items.find_all_by_item_id(id) }
  end

  def transactions
    invoice_parent.parent.transactions.find_all_by_invoice_id(id)
  end

  def is_paid_in_full?
    results = transactions.map { |transaction| transaction.result } 
    are_these_paid results
  end

  def are_these_paid(results)
    if results.include?("success")
      true
    elsif results.size.eql? 0
      false
    else
      false
    end
  end

  # def total
  #   paid_transactions = invoice_parent.fully_paid_invoices
  #   if paid_transactions.include?(self)
  #   else
  #     "$0.00"
  #   end
  # end

  def total
    prices = invoice_items.map { |item| item[0].unit_price * item[0].quantity }
    prices.reduce(&:+)
  end

  def determine_the_time(time_string)
    time = Time.new(0)
    return time if time_string == ""
    time_string = Time.parse(time_string)
  end

  def customer
    invoice_parent.parent.customers.find_by_id(customer_id)
  end

  def items
    invoice_items = invoice_parent.parent.invoice_items.find_all_by_invoice_id(id)
    invoice_items.map { |item| invoice_parent.parent.items.find_by_id(item.item_id) }
  end

end