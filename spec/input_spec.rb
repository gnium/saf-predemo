require_relative "../helpers/input"

describe "input" do
  let(:items) {Input.new("../files/input1.txt")}

  it "should turn the input file into an array" do
    expect(items.input_file.class).to be(Array)
  end

  it "should create a hash with the item name, qty, and price, exclusion, import" do  
    items_check = [ { name: "book", qty: 2, price: 12.49, category: false, import: false, total: 24.98 },
                    { name: "music CD", qty: 1, price: 14.99, category: true, import: false, total: 14.99 },
                    { name: "chocolate bar", qty: 1, price: 0.85, category: false, import: false, total: 0.85 }
                  ]
    expect(items.parse).to eq(items_check)
  end

end