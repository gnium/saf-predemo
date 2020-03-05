require './lib/calculator'
require './lib/print'

class Saf
  attr_reader :input

  def initialize(input = nil)
    @input_file_name = input
  end

  def parse_file
    file_path = File.dirname(File.dirname(__FILE__)) + '/files/' + @input_file_name
    if File.file?(file_path) 
        @input_file = File.open(file_path).to_a
        @exceptions = "book chocolates chocolate pills".chomp.split(' ')
        @items = []
    else 
        abort "File not found #{@input_file_name}"
    end
    @input_file.each do |item|
      item = item.strip.split("\s")
      line_item = { 
        name: name(item),
        amount: amount(item),
        price: price(item),
        category: classify_category(item),
        import: get_import(item),
        total: calculate_total(item)
      }
      @items << line_item
    end
    return @items
  end
  
  def name(item)
    puts item[1]
    limit = (item.index "at") - 1
    name = item[1..limit].join(" ")
    return name
  end
  
  def amount(item)
    return item[0].to_i
  end

  def price(item)
    start = (item.index "at") + 1
    limit = item.size
    price = item[start..limit]
    return price[0].to_f
  end

  def classify_category(item)
    intersection = item & @exceptions
    intersection = intersection.join(" ")
    return intersection != "" ? false : true
  end

  def get_import(item)
    check_import = item.include? 'imported'
    return check_import == true ? true : false
  end

  def calculate_total(item)
    total = amount(item) * price(item)
    return total
  end


  def calc
    prices = Calculator.new(@items)
    prices.total_all
    return prices
  end

  def print
    Print.review(@input_file, @input_file_name )
    receipt = Print.new(calc.items, calc.total_sales_tax, calc.total_price)
    receipt.show
  end

  def run
    parse_file
    calc
    print
  end
end

file = ARGV.first
prices = Saf.new(file)
prices.run
