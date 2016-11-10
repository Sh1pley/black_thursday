require_relative 'invoice'
require 'pry'

class InvoiceRepository
  attr_reader   :invoice,
                :parent,
                :all

  def initialize(invoice_data, parent = nil)
    @parent = parent
    @all = populate(invoice_data)
  end

  def populate(invoice_data)
    invoice_data.map { |invoice| Invoice.new(invoice, self) }
  end

  def find_by_id(id)
    all.find { |invoice| invoice.id.eql?(id) }
  end

  def fully_paid_invoices
    fully_paid = []
    all.each do |invoice|
      if invoice.is_paid_in_full?
        fully_paid << invoice
      end
    end
    fully_paid
  end

  def find_all_by_customer_id(customer_id)
    all.find_all { |invoice| invoice.customer_id.eql?(customer_id) }
  end

  def find_all_by_merchant_id(merchant_id)
    all.find_all { |invoice| invoice.merchant_id.eql?(merchant_id) }
  end

  def find_all_by_status(status)
    all.find_all { |invoice| invoice.status.eql?(status) }
  end

  def find_all_by_date(date)
    all.find_all do |invoice|
      invoice.created_at.strftime("%Y-%m-%d") == date.strftime("%Y-%m-%d")
    end
  end

  def inspect
    "#<#{self.class} #{@all.size} rows>"
  end

end