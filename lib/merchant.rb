require_relative 'merchant_repository'
require 'pry'

class Merchant
  attr_reader   :name,
                :id,
                :created_at,
                :updated_at,
                :merchant_parent

  def initialize(merchant_data, parent = nil)
    @merchant_parent = parent
    @name = merchant_data[:name]
    @id = merchant_data[:id].to_i
    @created_at = merchant_data[:created_at]
    @updated_at = merchant_data[:updated_at]
  end

  def items
    merchant_parent.find_all_items_by_merchant(self.id)
  end

  def invoices
    merchant_parent.find_all_invoices_by_merchant(self.id)
  end

  def customers
    customer_ids = invoices.map {|invoice| invoice.customer_id}
    customers = customer_ids.map do |customer|
      merchant_parent.parent.customers.find_by_id(customer)  # => can we make this 80 chars?/one line
    end
    customers.uniq
  end

end