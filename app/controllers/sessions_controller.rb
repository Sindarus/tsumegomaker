class SessionsController < ApplicationController
  def login
  end
  
  def login_attempt
    authorized_user = User.authenticate(params[:username_or_email],params[:password])
    if authorized_user
      session[:user_id] = authorized_user.id
      flash[:notice] = "Vous êtes connecté"
      redirect_to(:action => 'main', :controller => 'welcome')
    else
      flash[:notice] = "Mot de passe ou utilisateur invalid"
      flash[:color] = "invalid"
      render "login"
    end
  end

end
