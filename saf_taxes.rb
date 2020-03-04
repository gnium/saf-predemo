require './helpers/input'
require './helpers/calculator'
require './helpers/print'

class SafTaxes

  def initialize(filename)
    @filename = filename
  end

  def input
    file = Input.new(@filename)
    file.parse
    return file
  end

  def calc
    costs = Calculator.new(input.items)
    costs.total_all
    return costs
  end

  def print
    Print.review(input.input_file, @filename)
    receipt = Print.new(calc.items, calc.total_sales_tax, calc.total_price)
    receipt.show
  end

  def run
    input
    calc
    print
  end
end

filename = ARGV.first
purchase = SafTaxes.new(filename)
purchase.run
