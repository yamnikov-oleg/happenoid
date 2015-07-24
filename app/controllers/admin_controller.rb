class AdminController < ApplicationController
  require 'digest'

  before_action :save_referrer, only: [:login, :exit]
  before_action :pswd_from_db, only: [:enter, :update]

	def login
	end

  def enter
  	if pswd_from_params == @password.value
  		session['admin'] = true
  	end
  	redirect_back_or_to stories_path
  end

  def exit
  	session['admin'] = false
  	redirect_back_or_to stories_path
  end

  def edit
  end

  def update
    unless old_from_params == @password.value
      redirect_to admin_password_path, admin_password: 'Старый пароль неверен'
      return
    end
    @password.value = new_from_params
    if @password.save
      admin_password = 'Успешно'
    else
      admin_password = @password.errors[0].full_message
    end
    redirect_to admin_password_path, admin_password: admin_password
  end

  private

  def pswd_from_params
  	Digest::SHA512.hexdigest params[:password]
  end

  def old_from_params
    Digest::SHA512.hexdigest params[:old]
  end

  def new_from_params
    Digest::SHA512.hexdigest params[:new]
  end

  def pswd_from_db
    model = AdminPassword.first
    if model.nil?
      value = Digest::SHA512.hexdigest '123456'
      model = AdminPassword.new({value: value})
      model.save
    end
    @password = model
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