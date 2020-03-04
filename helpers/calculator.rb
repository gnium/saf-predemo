class Calculator

  attr_reader :total_sales_tax, :total_price, :items

  def initialize(items_input)
    @items = items_input
    @total_price = 0.0
    @total_sales_tax = 0.0
    @sum_categories_tax = 0.0
    @sum_imports_tax = 0.0
    @categories_tax = 0.1
    @imports_tax = 0.05
    @nearest_cent = 1 / 0.05
  end

  def capture_items(type)
    categories = @items.select { |item| item[type] == true }
    return categories
  end

  def round_tax(tax_amt)
    new_tax = ((tax_amt * @nearest_cent).ceil / @nearest_cent)
    return new_tax
  end

  def compute_tax(price, qty, tax)
    tax_amt = (price * qty) * tax
    adjusted_tax = round_tax(tax_amt)
    return adjusted_tax
  end

  def update_total(total, tax)
    total += tax
    total = total.round(2)
    return total
  end

#############
# categories Tax
#############

  def total_categories_tax(categories)
    categories.each do |category|
      tax_amt = compute_tax(category[:price], category[:qty], @categories_tax)
      category[:total] = update_total(category[:total], tax_amt)
      @sum_categories_tax += tax_amt
    end
  end

  def apply_categories_tax
    categories = capture_items(:category)
    total_categories_tax(categories)
    return @sum_categories_tax
  end

##############
# Import Tax
##############

  def total_import_tax(categories)
    categories.each do |category|
      tax_amt = compute_tax(category[:price], category[:qty], @imports_tax)
      category[:total] = update_total(category[:total], tax_amt)
      @sum_imports_tax += tax_amt
    end
  end

  def apply_import_tax
    categories = @items.select { |item| item[:import] == true }
    test = total_import_tax(categories)
    return @sum_imports_tax
  end

#########
# Total
#########

  def sum_taxes(category, import)
    tax_amt = category.to_f + import.to_f
    return tax_amt
  end

  def sales_tax
    @total_sales_tax = sum_taxes(apply_categories_tax, apply_import_tax)
    return @total_sales_tax
  end

  def capture_base_prices
    base_prices = @items.map { |item| item[:price] * item[:qty] }.flatten
    return base_prices
  end

  def sum_base_prices
    total_base_price = capture_base_prices.inject(:+)
    return total_base_price
  end

  def total_all
    @total_price = sum_base_prices + sales_tax
    return @total_price
  end

end