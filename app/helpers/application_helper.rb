module ApplicationHelper
	def admin?
		if session['admin']
			return true
		else
			return false
		end
	end
end
