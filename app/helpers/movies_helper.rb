module MoviesHelper
  # Checks if a number is odd:
  def oddness(count)
    count.odd? ?  "odd" :  "even"
  end

  def hilite_table(table_header)
    if(params[:sort].to_s == table_header)
      return 'hilite'
    else
      return nil
    end
  end
end
