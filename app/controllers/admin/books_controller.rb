# Don't forget to add menu item in app/views/shared/admin/_sidebar.html.erb
class Admin::BooksController < Admin::BaseController
  before_action :set_book, only: [:show, :edit, :update, :destroy]

  def index
    @books = Book.all.page(params[:page]).per(20)
    
    # Search functionality
    if params[:search].present?
      @books = @books.where("title ILIKE ? OR author ILIKE ? OR isbn ILIKE ?", 
                           "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%")
    end
    
    # Filter by availability
    case params[:filter]
    when 'available'
      @books = @books.available
    when 'out_of_stock'
      @books = @books.where(stock: 0)
    when 'low_stock'
      @books = @books.where('stock > 0 AND stock <= 5')
    end
    
    @books = @books.order(:title)
  end

  def show
  end

  def new
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    
    if @book.save
      redirect_to admin_book_path(@book), notice: 'Book was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @book.update(book_params)
      redirect_to admin_book_path(@book), notice: 'Book was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @book.destroy!
    redirect_to admin_books_path, notice: 'Book was successfully deleted.'
  end

  private

  def set_book
    @book = Book.find(params[:id])
  end

  def book_params
    params.require(:book).permit(:title, :author, :price, :description, :cover_image, :isbn, :stock)
  end
end
