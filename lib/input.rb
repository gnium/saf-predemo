class Input
  attr_reader :input_file, :items

  def initialize(location)
    @input_file = File.open(File.dirname(File.dirname(__FILE__)) + '/files/' + location).to_a
    @exceptions = "book chocolates chocolate pills".chomp.split(' ')
    @items = []
  end

  def parse
    @input_file.each do |item|
      item = item.strip.split(/\s/)
      line_item = { name: name(item),
        amount: amount(item),
        price: price(item),
        category: classify_category(item),
        import: classify_import(item),
        total: calculate_total(item)
      }
      @items << line_item
    end
    return @items
  end
  
  def amount(item)
    return item[0].to_i
  end

  def name(item)
    end_point = (item.index "at") - 1
    capture = item[1..end_point].join(" ")
    return capture
  end

  def price(item)
    start_point = (item.index "at") + 1
    end_point = item.size
    capture = item[start_point..end_point]
    return capture[0].to_f
  end

  def classify_category(item)
    intersection = item & @exceptions
    intersection = intersection.join(" ")
    return intersection != "" ? false : true
  end

  def classify_import(item)
    check_import = item.include? 'imported'
    return check_import == true ? true : false
  end

  def calculate_total(item)
    total = amount(item) * price(item)
    return total
  end
end
