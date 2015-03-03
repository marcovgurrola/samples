class Class
  def attr_accessor_with_history(attr_name)
    attr_name = attr_name.to_s
    # Getters
    class_eval %Q"
    def #{attr_name}
      @#{attr_name}
    end"
    class_eval %Q"
    def #{attr_name+"_history"}
      if !@values.nil?
        @values.take(@values.length - 1) if @values.length > 1
      else @values; end;
    end"

    #Setters
    class_eval %Q"
    def #{attr_name}=(val)
      @#{attr_name}=val
      @values = Array[nil] if @values.nil?
      @values.push(val)
    end"
  end
end