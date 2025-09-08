class BooksController < ApplicationController
  before_action :set_book, only: [:show]

  def index
    @books = Book.available.page(params[:page]).per(12)
    
    # Filter by author if specified
    @books = @books.by_author(params[:author]) if params[:author].present?
    
    # Search functionality
    if params[:search].present?
      @books = @books.where("title ILIKE ? OR author ILIKE ?", 
                           "%#{params[:search]}%", "%#{params[:search]}%")
    end
    
    @authors = Book.distinct.pluck(:author).compact.sort
  end

  def show
    @order = Order.new
  end

  private

  def set_book
    @book = Book.find(params[:id])
  end
end
