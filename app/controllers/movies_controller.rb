class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.all
    @restore_session=0

    #reset session if user clicks rotten potatoes title
    if(params[:sort].to_s == 'reset')
      session.clear
    end

    # sorting section
    if(params[:sort].to_s == 'title')
      session[:sort] = params[:sort]
      @movies = @movies.sort_by{|m| m.title }
    elsif(params[:sort].to_s == 'release')
      session[:sort] = params[:sort]
      @movies = @movies.sort_by{|m| m.release_date.to_s }
    elsif(session.has_key?(:sort))
      params[:sort] = session[:sort]
      @restore_session=1
    end

    # rating filter section
    if(params[:ratings] != nil)
      session[:ratings] = params[:ratings]
      @movies = @movies.find_all{ |m| params[:ratings].has_key?(m.rating) }
    elsif(session.has_key?(:ratings))
      params[:ratings] = session[:ratings]
      @restore_session=1
    end

    @all_ratings =  ['G','PG','PG-13','R']
    @selected_ratings = {}
    @all_ratings.each { |rating|
      if params[:ratings] == nil
        @selected_ratings[rating] = false
      else
        @selected_ratings[rating] = params[:ratings].has_key?(rating)
      end
    }

    # restore session
    if(@restore_session==1)
      redirect_to movies_path(:sort=>params[:sort], :ratings=>params[:ratings])
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
end
