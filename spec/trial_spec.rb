require_relative '../helpers/input'
require_relative '../helpers/calculator'
require_relative '../helpers/print'

describe "trial" do
  it "should correctly display output 1" do
    input = Input.new("../files/input1.txt")
    puts "-------------------------"
    puts "Input 1:"
    puts "-------------------------"
    puts input.input_file
    puts "-------------------------\n\n"
    input.parse
    costs = Calculator.new(input.items)
    costs.total_all
    receipt = Print.new(costs.items, costs.total_sales_tax, costs.total_price)
    puts "Output 1:"
    puts "-------------------------\n\n"
    receipt.show
    puts "-------------------------\n\n"
  end

  it "should correctly display output 2" do
    input = Input.new("../files/input2.txt")
    puts "Input 2:"
    puts "-------------------------"
    puts input.input_file
    puts "-------------------------\n\n"
    input.parse
    costs = Calculator.new(input.items)
    costs.total_all
    receipt = Print.new(costs.items, costs.total_sales_tax, costs.total_price)
    puts "Output 2:"
    puts "-------------------------\n\n"
    receipt.show
    puts "-------------------------\n\n"
  end

  it "should correctly display output 3" do
    input = Input.new("../files/input3.txt")
    puts "Input 3:"
    puts "-------------------------"
    puts input.input_file
    puts "-------------------------\n\n"
    input.parse
    costs = Calculator.new(input.items)
    costs.total_all
    receipt = Print.new(costs.items, costs.total_sales_tax, costs.total_price)
    puts "Output 3:"
    puts "-------------------------\n\n"
    receipt.show
    puts "-------------------------\n\n"
  end

end

