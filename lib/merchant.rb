require 'pry'
require 'csv'

class FakeRepository
  attr_reader  :all

  def initialize
    @handle = CSV.open './data/merchants.csv', headers: true, header_converters: :symbol
    @all    = @handle.map { |line| Merchant.new(line).merchant }
  end

  def find_by_id(id)
    @all.find { |merchant| merchant["id"].eql?(id) }
  end 

  def find_by_name(name)
    @all.find { |merchant| merchant["name"].eql?(name) }
  end

  def find_all_by_name(fragment)
    results = @all.find_all do |merchant|
      merchant["name"].downcase.include?(fragment.downcase)
    end
  results
  end
end

class Merchant < FakeRepository
  attr_reader  :merchant

  def initialize(line)
    @line     = line
    @merchant = { "id" => id, "name" => name }
  end

  def id
    @line[:id]
  end

  def name
    @line[:name]
  end

end

puts FakeRepository.new.find_all_by_name("Jai")
