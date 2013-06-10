class UsersController < ApplicationController
	load_and_authorize_resource
	before_filter :authenticate_user!

	def index
		authorize! :index, @user, :message => 'Not authorized as an administrator.'
		@users = User.all
	end

	def update
		authorize! :update, @user, :message => 'Not authorized as an administrator.'
		@user = User.find(params[:id])
		if @user.update_attributes(params[:user], :as => :admin)
			redirect_to users_path, :notice => "User updated."
		else
			redirect_to users_path, :alert => "Unable to update user."
		end
	end

	def destroy
		authorize! :destroy, @user, :message => 'Not authorized as an administrator.'
		user = User.find(params[:id])
		unless user == current_user
			user.destroy
			redirect_to users_path, :notice => "User deleted."
		else
			redirect_to users_path, :notice => "Can't delete yourself."
		end
	end

	def show
		@user = User.find(params[:id])
		@totp = ROTP::TOTP.new(@user.otp_secret)
		@qr_string = @totp.provisioning_uri("auth test - #{@user.email}")
		@qr_code = QREncoder.encode(@qr_string)
		@qr_code.png(pixels_per_module: 4, margin: 1).save("public/images/qrcode.png")
	end

	def reset_secret
		@user = User.find(params[:id])
		@user.otp_secret = ROTP::Base32.random_base32
		@user.save
		redirect_to user_path
	end
end
