class BooksController < ApplicationController

  def show
    @book = Book.find(params[:id])
    @new_book = Book.new
    @book_comment = BookComment.new
    #ReadCountを新しく作成
    unless ReadCount.find_by(user_id: current_user.id, book_id: @book.id)
      current_user.read_counts.create(book_id: @book.id)
    end
  end

  def index
    @books = Book.includes(:favorites).all
    # 1週間以内のfavorites数でソートする
    @books = @books.sort do |a, b|
      # いいねの数で降順にする
      b.favorites.select { |fav| fav.created_at > 1.week.ago }.size <=>
      a.favorites.select { |fav| fav.created_at > 1.week.ago }.size
    end
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
    @book = Book.find(params[:id])
    redirect_to users_path unless @book.user == current_user
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.delete
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end
end
