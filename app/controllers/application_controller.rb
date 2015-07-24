class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected

  def admin_only!
  	unless admin?
  		if request.referrer and request.referrer != request.original_url
  			back = request.referrer
  		else
  			back = stories_path
  		end

  		redirect_to back, restricted: true
  		return false
  	else
  		return true
  	end
  end
end
