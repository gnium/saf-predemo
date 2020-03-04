require_relative '../helpers/calculator'

describe "calculator" do

  it "should add the category tax to the item total" do
    items = [ { name: "music CD", qty: 1, price: 14.99, category: true, import: false, total: 14.99 } ]
    receipt = Calculator.new(items)
    receipt.apply_categories_tax
    receipt.items[0][:total].should == 16.49
  end

  it "should total categories tax" do
    items = [ { name: "book", qty: 1, price: 12.49, category: false, import: false, total: 12.49},
              { name: "music CD", qty: 1, price: 14.99, category: true, import: false, total: 14.99 },
              { name: "chocolate bar", qty: 1, price: 0.85, category: false, import: false, total: 0.85 }
            ]
    receipt = Calculator.new(items)
    receipt.apply_categories_tax.should == 1.5
  end

  it "should add the import tax to the item total" do
    items = [ { name: "imported bottle of chocolates", qty: 1, price: 10.00, category: false, import: true, total: 10.00 } ]
    receipt = Calculator.new(items)
    receipt.apply_import_tax
    receipt.items[0][:total].should == 10.50
  end

  it "should total import tax" do
    items = [ { name: "imported bottle of chocolates", qty: 1, price: 10.00, category: false, import: true, total: 10.00 },
              { name: "imported bottle of perfume", qty: 1, price: 47.50, category: true, import: true, total: 47.50 }
            ]
    receipt = Calculator.new(items)
    receipt.apply_import_tax.should == 2.90
  end

  it "should total the categories and import tax" do
    items = [ { name: "imported bottle of chocolates", qty: 1, price: 10.00, category: false, import: true, total: 10.00 },
              { name: "imported bottle of perfume", qty: 1, price: 47.50, category: true, import: true, total: 47.50 }
            ]
    receipt = Calculator.new(items)
    receipt.sales_tax.should == 7.65

    items2 = [ { name: "book", qty: 1, price: 12.49, category: false, import: false, total: 12.49},
              { name: "music CD", qty: 1, price: 14.99, category: true, import: false, total: 14.99 },
              { name: "chocolate bar", qty: 1, price: 0.85, category: false, import: false, total: 0.85 }
            ]
    receipt2 = Calculator.new(items2)
    receipt2.sales_tax.should == 1.50
  end

  it "should take the base price of the items and sum them" do
    items = [ { name: "imported bottle of chocolates", qty: 1, price: 10.00, category: false, import: true, total: 10.50 },
              { name: "imported bottle of perfume", qty: 1, price: 47.50, category: true, import: true, total: 54.65 }
            ]
    receipt = Calculator.new(items)
    receipt.capture_base_prices.should == [10.00, 47.50]
    receipt.sum_base_prices.should == 57.50
  end

  it "should sum the base price of the items and sales tax" do
    items = [ { name: "imported bottle of chocolates", qty: 1, price: 10.00, category: false, import: true, total: 10.00 },
              { name: "imported bottle of perfume", qty: 1, price: 47.50, category: true, import: true, total: 47.50 }
            ]
    receipt = Calculator.new(items)
    receipt.total_all.should == 65.15
  end

end