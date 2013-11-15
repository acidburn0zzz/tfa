require 'spec_helper'

def help
	:available
end

### UTILITY METHODS ###

def create_visitor
	@visitor ||= { :name => "Testy McUserton", :email => "example@example.com",
		:password => "changeme", :password_confirmation => "changeme",
		:otp_secret => "lqdjuj4z6cvudk3v"
	}
end

def find_user
	@user ||= User.first conditions: {:email => @visitor[:email]}
end

def create_unconfirmed_user
	create_visitor
	delete_user
	sign_up
	visit '/users/sign_out'
end

def create_user
	create_visitor
	delete_user
	@user = FactoryGirl.create(:user, email: @visitor[:email], :otp_secret => @visitor[:otp_secret])
end

def create_admin
	create_visitor
	delete_user
	@user = FactoryGirl.create(:user, email: @visitor[:email], :otp_secret => @visitor[:otp_secret])
	@user.add_role :admin
end

def delete_user
	@user ||= User.first conditions: {:email => @visitor[:email]}
	@user.destroy unless @user.nil?
end

def sign_up
	delete_user
	visit '/users/sign_up'
	fill_in "Name", :with => @visitor[:name]
	fill_in "Email", :with => @visitor[:email]
	fill_in "user_password", :with => @visitor[:password]
	fill_in "user_password_confirmation", :with => @visitor[:password_confirmation]
	click_button "Sign up"
	find_user
end

def sign_in
	visit '/users/sign_in'
	fill_in "Email", :with => @visitor[:email]
	fill_in "Password", :with => @visitor[:password]
	click_button "Sign in"
end

def sign_out
	visit '/users/sign_out'
end

def two_factor
	totp = ROTP::TOTP.new(@visitor[:otp_secret])
	fill_in "code", :with => totp.now
	click_button "Submit"
end

def login_user
	create_user
	create_visitor
	sign_out
	sign_in
	two_factor
end

def login_admin
	create_admin
	sign_out
	sign_in
	two_factor
end
