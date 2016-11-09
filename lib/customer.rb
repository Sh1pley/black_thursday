require 'time'
require 'bigdecimal'

class Customer
  attr_reader   :id,
                :first_name,
                :last_name,
                :created_at,
                :updated_at,
                :customer_parent

  def initialize(customer_data, parent = nil)
    @customer_parent = parent
    @id             = customer_data[:id].to_i
    @first_name     = customer_data[:first_name]
    @last_name      = customer_data[:last_name]
    @created_at     = determine_the_time(customer_data[:created_at])
    @updated_at     = determine_the_time(customer_data[:updated_at])
  end

  def determine_the_time(time_string)
    time = Time.new(0)
    return time if time_string == ""
    time_string = Time.parse(time_string)
  end

  def invoices
    customer_parent.parent.invoices.find_all_by_customer_id(id)
  end

  def merchants
    merchant_ids = invoices.map {|invoice| invoice.merchant_id}
    merchants = merchant_ids.map do |merchant|
      customer_parent.parent.merchants.find_by_id(merchant)
    end
    merchants.uniq
  end

end