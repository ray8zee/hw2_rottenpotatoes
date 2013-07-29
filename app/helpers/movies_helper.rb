module MoviesHelper
  # Checks if a number is odd:
  def oddness(count)
    count.odd? ?  "odd" :  "even"
  end
  def sortable(name, column = nil)
    options = { :sort => column, :ratings => @ratings }
    link_to name, options, { :id => column + "_header" }
  end
  def hilite(column)
    column == @sort ? "hilite" : nil
  end
end
