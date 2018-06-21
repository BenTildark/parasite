class SessionsController < ApplicationController

  if Rails.env.production?
    force_ssl only: [:new, :create]
  end

	def new
  end
  
  def create
    user = User.find_by(email: params[:email])
    if user && verify_recaptcha(model: user) && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_url, notice: 'Logged in!'
    else
      flash.now.alert = 'Error! either your email, password is invalid or you failed reCAPTCHA verification. Please try again.'
      render :new
    end
  end
  
  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: 'Logged out!'
  end
end
