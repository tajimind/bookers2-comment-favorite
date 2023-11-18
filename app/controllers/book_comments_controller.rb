class BookCommentsController < ApplicationController
  before_action :authenticate_user! # ログインユーザーのみアクセス可能とする

  def create
    @book = Book.find(params[:book_id])
    @comment = @book.book_comments.new(book_comment_params)
    @comment.user = current_user
    @comment.user_id = current_user.id

    if @comment.save
      flash[:success] = 'Comment created successfully.'
    else
      flash[:error] = 'Error creating comment.'
    end

    redirect_back(fallback_location: root_path) # 元の画面に遷移する
  end

  def destroy
    @comment = BookComment.find(params[:id])


    if @comment.user == current_user
      @comment.destroy
      flash[:success] = 'Comment deleted successfully.'
    else
      flash[:error] = 'You are not authorized to delete this comment.'
    end

    redirect_back(fallback_location: root_path)
  end

  private

  def book_comment_params
    params.require(:book_comment).permit(:comment)
  end
end