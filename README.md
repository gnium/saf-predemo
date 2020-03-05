## General Requirements
- Use either Ruby or Javascript. If you feel more comfortable with another language, please let us know and we can discuss. 
- Do not use any external libraries to solve this problem. You may only use external libraries or tools for building or testing purposes (e.g., Rspec, Jest, Mocha, etc.).
- Include detailed instructions on how to run the application and an explanation of assumptions you make (if any)


**IMPORTANT:**  
Please limit the amount of time you spend on the problem to **4 hours**. If you haven't completed the challenge within the allotted time, please submit the work you have completed. Focus on implementing the requirements with the best code you can produce within the given timeframe.


## Problem Statement 

This problem requires some kind of input. You are free to implement any mechanism for feeding the input into your solution. You should provide sufficient evidence that your solution is complete by, as a minimum, indicating that it works correctly against the supplied test data.

**Basic sales tax** is applicable at a rate of **10%** on all categories, **except** books, food, and medical products that are exempt. **Import duty** is an additional sales tax applicable on all imported categories at a rate of 5%, with no exemptions.

When I purchase items I receive a receipt which lists the name of all the items and their price (including tax), finishing with the total cost of the items, and the total amounts of sales taxes paid. The rounding rules for sales tax are that for a tax rate of n%, a shelf price of p contains (np/100 rounded up to the nearest 0.05) amount of sales tax.


Write an application that prints out the receipt details for these shopping baskets:

### Input

#### Input 1:
```
2 book at 12.49
1 music CD at 14.99
1 chocolate bar at 0.85
```

#### Input 2:
```
1 imported box of chocolates at 10.00
1 imported bottle of perfume at 47.50
```

#### Input 3:
```
1 imported bottle of perfume at 27.99
1 bottle of perfume at 18.99
1 packet of headache pills at 9.75
3 box of imported chocolates at 11.25
```

### Output

#### Output 1:
```
2 book: 24.98
1 music CD: 16.49
1 chocolate bar: 0.85
Sales Taxes: 1.50
Total: 42.32
```

#### Output 2:
```
1 imported box of chocolates: 10.50
1 imported bottle of perfume: 54.65
Sales Taxes: 7.65
Total: 65.15
```

#### Output 3:
```
1 imported bottle of perfume: 32.19
1 bottle of perfume: 20.89
1 packet of headache pills: 9.75
3 imported box of chocolates: 35.55
Sales Taxes: 7.90
Total: 98.38
```
### How to Run
`ruby run_tax.rb <filename>.txt`  
*Note*: The text file must be placed in the `input` folder. 3 files from the problem have been included for your convenience.  
#### Files:
- input1.txt
- input2.txt
- input3.txt
  
***
### Testing
Tests were done with `rspec`.  
`rspec spec/<filename>.rb` - individual test
`rspec spec` - run all tests
#### Files:
- input_spec.rb - Testing for file input
- caculator_spec.rb - Testing for caculating sales tax and totals
- print_spec.rb - Testing for displaying the output
- trial_spec.rb - Testing all 3 inputs  
  
***
### Assumptions
1. The input text file follows the following syntax:
    <pre>
        1 book at 12.49
        amount, name, "at", price
    </pre>
2. Product Quanity is a whole positive number
3. Price is a positive number
4. Items to be excluded from the categories sales tax (10%) is included in a text file called `exclusions.txt` placed in the root directory of this script.
5. Imported items have the word 'imported' in them.  
  
***
### Flow
A high level flow of how this application works is as follows:  
**1.**  User runs `run_tax.rb` with the `text` file of their choice located in the `input` directory.  

**2.**  `run_tax.rb` runs and calls `/lib/files` where the text file is loaded and turned into an array and then the following occurs:  
#### text file:
>   1 book at 1.99
    1 imported watches at 5.99

#### text file to array:
    `["1 book at 1.99", "1 imported watch at 5.99"]`

#### array is split up:
    [ ["1", "book", "at", "1.99"], ["1", "imported", "watch", "at", "5.99"] ]

#### split up arrays are converted into a hash:
    ["1", "book", "at", "1.99"]
    index:   0    1       2     3

- `:name` - determined by taking the `index 1` (we can assume `index 0` is the `item quantity`) and taking the `ending index of "at" - 1` which would be `index 1` in this case. For the `imported watch`, `index 1` to `index 2` would be joined, creating `"imported watch"`  and this is determined by the starting point being `index 1` and the ending point being whatever the `index` of `"at"` is, which in this case is `3` so `3 - 1` = `index 2`.

- `:amount` - determined by taking `index 0` because it is assumed the first item would be quantity.
- `:price` - determined by find the `index of "at"` and `adding` `1`.

- `:category` - determined by looking up the `exclusions.txt` list and checking if any items in the array match the items listed in `exclusions.txt`. If one is found, the boolean of `false` is applied, otherwise it is set to `true`.

- `:import` - determined by checking if the `array` has the `string` `"imported"`. If found a boolean of `true` is set, else it is set to `false`.

- `:total` - determined by multiplying the `amount` * `price`.

While, turning the array into a array of hashes you can observe the `keys` `:category` and `:import`, this is the part where tax rules are applied. `:category` can be `true` if the item is not in `exclusions.txt`, or it is `false` if it is listed in `exlclusions.txt`.

Similarly, `:import` can be `true` if the `string` `"imported"` is found and if it is not found it is `false`.  
  
**3.**  Next the `/lib/calculator` is called. This is where the `categories tax`, `import tax`, `total sales tax` and `total price` will be calculated.
- `@sum_categories_tax` is calculated by checking the array of hashes for a value of `true`.
- `@sum_import_tax` is calculated by checking the array of hashes for a value of `true`.
- `@total_sales_tax` is calculated by adding `sum_categories_tax` and `sum_imports_tax`.
- `@total_price` is calculated by adding `@total_sales_price` to the `sum_base_prices` (this is the sum of the price of the items (price * amount) before any taxes are applied).
The item `hash` passed into `Calculator`, `:total` is updated to reflect `price` + `categories tax` + `imports tax`.  
**Notes about rounding:**
<pre>The problem says to round UP to the nearest 0.05 cent. This is determined by taking 1 / 0.05 = 20.
    @nearest_cent is set to (1 / 0.05)
    Rounding UP to the nearest 0.05 cent is done by the following:
        ((taxable amount * @nearest_cent).ceil / @nearest_cent)
        .ceil instead of .round is used because we want to round UP.
</pre>  
  
**4.** After the totals are calculated, `/lib/print` is called. This is what outputs everything into the terminal.  

The updated items `hash` from running `Calculator` is passed into `Print`, along with `total_sales_tax` and `total_price`.

The values of `:total`, `total_sales_tax`, and `total_price` are all "scrubbed" with a method that turns the `integer` into a `string` and then applies `rjust(2, '0')` to make sure 2 decimal spots is displayed.  
<br />
**5.**  The output should now be as follows:
<pre>Input from input1.txt:
1 book at 12.49
1 music CD at 14.99
1 chocolate bar at 0.85

Output:
1 book: 12.49
1 music CD: 16.49
1 chocolate bar: 0.85
Sales Taxes: 1.50
Total: 29.83</pre>
***
### Thought Process
As I was writing this, I broke the application down into 3 major components:

- `Input` - where a file is taken in and broken down into something more readable
- `Calculator` - where the readable format taken from input is used to calculate the total values
- `Print` - where the input, revised input and total values are taken to be outputed

I am fairly new to programming and to test driven development in general. This problem was quite challenging as a beginner because having just learned Ruby about 3 months ago, I currently have a narrow linear way of thinking through the algorithm. With test driven development, it is almost going backwards in a way (thinking of tests to write first then coding). So it is a bit of a shift in gears from just coding (going forwards) to test driven development (going backwards).

However this was an excellent excercise to get better aquainted with Test Driven Development and with Object Oriented Programming in general. I think I have improved a whole lot from the last 3 months I spent at The Starter League.

### Review
I am sure there is quite a bit of refactoring that can be done. I still have a lot to learn, but I am learning quick!