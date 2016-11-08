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

  def transactions
    invoice_parent.parent.transactions.find_all_by_invoice_id(id)
  end

  def is_paid_in_full?
    results = transactions.map { |transaction| transaction.result } 
    if results.size == 0
      false
    elsif results.include?("failed")
      false
    elsif results.each { |result| result.eql?("success")}
      true
    end
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