require_relative '../lib/calculator'

describe "calculator" do
  let(:items_1) {[ { name: "music CD", amount: 1, price: 14.99, category: true, import: false, total: 14.99 } ]}
  let(:items_2) {[ { name: "book", amount: 1, price: 12.49, category: false, import: false, total: 12.49},
    { name: "music CD", amount: 1, price: 14.99, category: true, import: false, total: 14.99 },
    { name: "chocolate bar", amount: 1, price: 0.85, category: false, import: false, total: 0.85 }
  ]}
  let(:items_3){[ { name: "imported bottle of chocolates", amount: 1, price: 10.00, category: false, import: true, total: 10.00 } ]}
  let(:items_4){[ { name: "imported bottle of chocolates", amount: 1, price: 10.00, category: false, import: true, total: 10.00 },
    { name: "imported bottle of perfume", amount: 1, price: 47.50, category: true, import: true, total: 47.50 }
  ]}

  it "should round the ta up to the nearest 0.05"  do
    tax_amnt = 1.1233
    calc = Calculator.new(items_1)
    tax = calc.round_tax(tax_amnt)
    expect(tax).to eq(1.15)
  end

  it "should add the category tax to the item total" do
    receipt = Calculator.new(items_1)
    receipt.apply_categories_tax
    expect(receipt.items[0][:total]).to eq(16.49)
  end

  it "should total categories tax" do
    receipt = Calculator.new(items_2)
    expect(receipt.apply_categories_tax).to eq(1.5)
  end

  it "should add the import tax to the item total" do
    receipt = Calculator.new(items_3)
    receipt.apply_import_tax
    expect(receipt.items[0][:total]).to eq(10.50)
  end

  it "should total import tax" do
    receipt = Calculator.new(items_4)
    expect(receipt.apply_import_tax).to eq(2.90)
  end

  it "should total the categories and import tax" do
    receipt = Calculator.new(items_4)
    expect(receipt.sales_tax).to eq(7.65)
    items2 = [ { name: "book", amount: 1, price: 12.49, category: false, import: false, total: 12.49},
              { name: "music CD", amount: 1, price: 14.99, category: true, import: false, total: 14.99 },
              { name: "chocolate bar", amount: 1, price: 0.85, category: false, import: false, total: 0.85 }
            ]
    receipt2 = Calculator.new(items2)
    expect(receipt2.sales_tax).to eq(1.50)
  end

  it "should take the base price of the items and sum them" do
    items = [ { name: "imported bottle of chocolates", amount: 1, price: 10.00, category: false, import: true, total: 10.50 },
              { name: "imported bottle of perfume", amount: 1, price: 47.50, category: true, import: true, total: 54.65 }
            ]
    receipt = Calculator.new(items)
    expect(receipt.capture_base_prices).to eq([10.00, 47.50])
    expect(receipt.sum_base_prices).to eq(57.50)
  end

  it "should sum the base price of the items and sales tax" do
    receipt = Calculator.new(items_4)
    expect(receipt.total_all).to eq(65.15)
  end

end