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
    if (!params[:ratings] && session[:ratings]) || (!params[:sort] && session[:sort])
      flash.keep
      ratings = params[:ratings] || session[:ratings]
      sort_by = params[:sort] || session[:sort]
      redirect_to movies_path(:ratings => ratings, :sort => sort_by)
    end
    
    @all_ratings = Movie.all_ratings
    
    sort_by = params[:sort]
    ratings = params[:ratings]
    
    if ratings
      @movies = Movie.where(:rating => ratings.keys).order(sort_by)
      @selected = ratings.keys
    else
      @movies = Movie.order(sort_by)
      @selected = @all_ratings
    end

    @title_header_class = 'hilite' if sort_by == 'title'
    @release_date_header_class = 'hilite' if sort_by == 'release_date'
    
    session[:sort] = sort_by
    session[:ratings] = ratings
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
