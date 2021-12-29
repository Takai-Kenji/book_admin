class BooksController < ApplicationController
    protect_from_forgery expect: [:destroy]
    before_action :set_book, only: [:destroy]
    around_action :action_logger, only: [:destroy]


    def show 
        # @book = Book.find(params[:id]) #本の情報を取得してコントローラー内のインスタンス変数として保持する
        respond_to do |format| 
            format.html
            format.json
        end
    end
    #destroyメソッド追加
    def destroy
    # @book = Book.find(params[:id])
    @book.destroy
    respond_to do |format|
        format.html { redirect_to "/"}
        format.json { head : no_content}
    end

    private

    def set_book
        @book = Book.find(params[:id])
    end

    def action_logger
        logger.info "around-before"
        yield
        logger.info "around-after"
    end
end
