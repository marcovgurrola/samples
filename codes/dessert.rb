class Dessert
  def initialize(name, calories)
    @name = name
    @calories = calories
  end
  
  #Getters
  def name
    @name
  end
  def calories
    @calories
  end
  
  #Setters
  def name=(new_name)
    @name = new_name  
  end
  def calories=(new_calories)
    @calories = new_calories
  end
  
  def healthy?
    calories < 200 ? true : false
  end
  def delicious?
    true
  end
end

class JellyBean < Dessert
  def initialize(flavor)
    @flavor = flavor
    self.name = @flavor + ' jelly bean'
    self.calories = 5
  end
  
  #Getters and setters
  def flavor
    @flavor
  end
  def flavor=(new_flavor)
    @flavor = new_flavor
  end

  def delicious?
    flavor == 'licorice' ? false : true
  end
end

j = JellyBean.new('apple')
print j.name, j.flavor, j.calories
