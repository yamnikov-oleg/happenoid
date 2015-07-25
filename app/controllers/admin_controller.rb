class AdminController < ApplicationController
  require 'digest'

  before_action :save_referrer, only: [:login, :exit]
  before_action :pswd_from_db, only: [:enter, :update]
  before_filter :admin_only!, only: [:edit, :update]

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
      flash[:admin_password] = 'Старый пароль неверен'
      redirect_to admin_password_path
      return
    end

    @password.value = new_from_params
    if @password.save
      admin_password = 'Успешно'
    else
      admin_password = @password.errors.full_messages[0]
    end
    flash[:admin_password] = admin_password
    redirect_to admin_password_path
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
