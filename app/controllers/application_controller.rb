class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include ApplicationHelper

  protected

  def redirect_back_or_to url
    if request.referrer and request.referrer != request.original_url
      back = request.referrer
    else
      back = url
    end

    redirect_to back
  end

  def restricted_redirect
    if request.referrer and request.referrer != request.original_url
      back = request.referrer
    else
      back = stories_path
    end

    redirect_to back, restricted: true
  end

  def admin_only!
  	unless admin?
  		restricted_redirect
  		return false
  	else
  		return true
  	end
  end
end
