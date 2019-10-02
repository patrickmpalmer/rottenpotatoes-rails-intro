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

  def sort(movie)
    if(params[:sort].to_s == 'title')
     return movie.title
    elsif(params[:sort].to_s == 'release')
     return movie.release_date.to_s
    end 
  end

  def raitings(rating)
    if(params[:ratings] == nil)
     return false
    end
   return params[:ratings].has_key?(rating)
  end
end
