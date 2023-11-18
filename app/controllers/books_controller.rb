class BooksController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update, :destroy], except: [:index, :show]

  def new
    @book = Book.new
  end

  def create
    @book = Book.new(books_params)
    @book.user_id = current_user.id
    if @book.save
      flash[:success] = "Book was successfully created."
      redirect_to book_path(@book)
    else
      @user = current_user
      @books = Book.all
      render 'index'
    end
  end

  def index
    @book = Book.new
    @books = Book.all
    @user = current_user
    @book_comment = BookComment.new
  end

  def show
    @book = Book.find(params[:id])
    @books = Book.new
    @user = current_user
    @book_comment = BookComment.new
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])

    if @book.update(books_params)
      flash[:success] = "Book was successfully updated."
      redirect_to book_path(@book)
    else
      flash[:error] = 'Error updating user profile.'
      render :edit
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  # 投稿データのストロングパラメータ
  private

  def books_params
    params.require(:book).permit(:title, :body)
  end

  private

  def ensure_correct_user
    @book = Book.find(params[:id])
    unless @book.user == current_user
      redirect_to books_path
    end
  end
end
