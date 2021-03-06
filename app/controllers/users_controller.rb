class UsersController < ApplicationController

   before_action :signed_in_user, only: [:edit, :update, :show, :index, :destory]
   before_action :correct_user, only: [:edit, :update]
   before_action :admin_user, only: :destroy
   before_action :loggedin_revisiting, only: [:new, :create]
  




  def destroy
      User.find(params[:id]).destroy
      flash[:success] = "User deleted."
      redirect_to users_url 

  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def new
     @user = User.new
  end
  
  def create
      @user=User.new(user_params)
      if @user.save
         sign_in @user
         flash[:success] = "Welcome to the Sample App!"
         redirect_to @user
      else
         render "new"
      end
  end
   
   def show
      @user = User.find(params[:id])
      @microposts = @user.microposts.paginate(page: params[:page])
   end  

   def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end


  def following
    if signed_in?
      @title = "Following"
      @user = User.find(params[:id])
      @users = @user.followed_users.paginate(page: params[:page])
      render 'show_follow'
    else
      redirect_to signin_path
    end
    
  end

  def followers
    if signed_in?
      @title = "Followers"
      @user = User.find(params[:id])
      @users = @user.followers.paginate(page: params[:page])
      render 'show_follow'
    else
      redirect_to signin_path
    end    
  end

  private
  def user_params
     params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_url, notice: "Please sign in."
    end
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end  

  def admin_user
    redirect_to(root_url) unless current_user.admin?
    
  end



  def loggedin_revisiting
      if signed_in?
        redirect_to root_url, notice: "Already logged in"     
      end
  end

end
