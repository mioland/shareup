class PostsController < ApplicationController
    before_action :authenticate_user!
  
    def index
      @posts = Post.limit(10).includes(:photos, :user).order('created_at DESC')
    end
  
    def new
      @post = Post.new
    end
  
    def create
      @post = current_user.posts.build(post_params)
      if @post.save
        flash[:notice] = '投稿に成功しました。'
        redirect_to root_path
      else
        flash.now[:alert] = '投稿に失敗しました。'
        render :new
      end
    end
  
    private
      def post_params
        params.require(:post).permit(:tag_list, :title, :content).merge(user_id: current_user.id)
      end
end