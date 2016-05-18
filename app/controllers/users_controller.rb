class UsersController < ApplicationController

  before_filter :save_login_state, :only => [:new, :create]

  def new
    @user = User.new
  end
  
  def create
    permitted = params.require(:user).permit(:username, :email, :password, :password_confirmation)
    @user = User.new(permitted)
    if @user.save
      flash[:notice] = "Vous êtes enregistré"
      flash[:color] = "valid"
    else
      flash[:notice] = "Il y a une erreur dans le formulaire"
      flash[:color] = "invalid"
    end
    render "new"
  end
end
