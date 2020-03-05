class Print

  def initialize(line_items, total_sales_tax, total_price)
    @items = line_items
    @sales_tax = total_sales_tax
    @price = total_price
  end

  def two_digs(item)
    item = "%.2f" % item
    return item
  end

  def display_item(item)
      item[:total] = two_digs(item[:total])
      puts "#{item[:amount]} #{item[:name]}: #{item[:total]}"
  end

  def display_sales_tax
    @sales_tax = two_digs(@sales_tax)
    puts "Sales Taxes: #{@sales_tax}"
  end

  def display_price
    @price = two_digs(@price)
    puts "Total: #{@price}"
  end

  def show
    puts "Output: "
    @items.each do |item|
      display_item(item)
    end
    display_sales_tax
    display_price
  end

  def self.review(input, filename)
    puts "Input from #{filename}:"
    puts input
    puts "\n"
  end
end