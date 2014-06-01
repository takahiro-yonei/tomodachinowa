class SessionsController < ApplicationController


  def callback
    auth = request.env['omniauth.auth']

    user = User.where(provider: auth['provider'], uid: auth['uid']).first
    if(user.blank?)
      user = User.create_with_omniauth(auth)
    end

    session[:user_id] = user.id
    redirect_to root_path, :notice => ''
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end
end
