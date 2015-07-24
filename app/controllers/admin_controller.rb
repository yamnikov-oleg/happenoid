class AdminController < ApplicationController
  before_action :save_referrer, only: [:login, :exit]

	def login
	end

  def enter
  	if pswd_from_params == '1234'
  		session['admin'] = true
  	end
  	redirect_back_or_to stories_path
  end

  def exit
  	session['admin'] = false
  	redirect_back_or_to stories_path
  end

  private

  def pswd_from_params
  	params['password']
  end

  def save_referrer
    session[:return_to] ||= request.referrer
  end

  def redirect_back_or_to url
    if session[:return_to]
      redirect_to session.delete(:return_to)
    else
      redirect_to url
    end
  end

end
