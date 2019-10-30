class UsersController < ApplicationController
    before_action :set_user, only: %i(show following followers)

    def index
        @users = User.all.page(params[:page]).per(USER_PER)
    end

    def show
        @posts = Post.where(user_id: @user.id).order('created_at DESC').page(params[:page]).per(USER_PER)
    end
  
    def following
      @user = User.find(params[:id])
    end
  
    def followers
      @user = User.find(params[:id])
    end

    def likes
      @user = User.find(params[:id])
      @posts = Kaminari.paginate_array(posts).page(params[:page]).per(POST_PER)
    end
    
    def liked
      @user = User.includes(posts: [:likes, :photos]).find(params[:id])
      @posts = Kaminari.paginate_array(posts).page(params[:page]).per(POST_PER)
    end
    
    def notifications
      @notifications = Notification.where(to_user_id: current_user.id).order('created_at DESC').page(params[:page]).per(INDEX_PER)
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

end