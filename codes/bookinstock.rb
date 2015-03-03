class BookInStock
    #attr_accessor :isbn, :price
    
    def initialize(isbn, price)
        validate_isbn(isbn)
        validate_price(price)
        
        @isbn = isbn
        @price = price
    end
    
    #Getters and setters
    def isbn
        @isbn
    end
    
    def isbn=(new_isbn)
        validate_isbn(new_isbn)
        @isbn = new_isbn
    end
    
    def price
        @price
    end
    
    def price=(new_price)
        validate_price(new_price)
        @price = new_price
    end
    
    def price_as_string
        "$#{format("%.2f",@price)}";
    end
    
    #Validation methods
    def validate_isbn(isbn)
        if isbn.nil? || !isbn.is_a?(String) || isbn.size == 0
            raise ArgumentError.new('isbn is not valid!')
        end
    end
    
    def validate_price(price)
        if price.nil? || !price.is_a?(Numeric) || price <= 0
            raise ArgumentError.new('price is not valid!')
        end
    end
end