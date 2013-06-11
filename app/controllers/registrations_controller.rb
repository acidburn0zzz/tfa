class RegistrationsController < Devise::RegistrationsController
	protected

	def after_sign_up_path_for(resource)
		user = User.find(current_user.id)
		user.otp_secret = ROTP::Base32.random_base32
		user.save
		reset_secret_user_path(current_user.id)
	end
end
