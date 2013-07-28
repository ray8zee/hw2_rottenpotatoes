module ApplicationHelper
  def sortable(name, column = nil)
    link_to name, { :sort => column }, { :id => column + "_header" }
  end
  def hilite(column)
    column == sort_column ? "hilite" : nil
  end
end
