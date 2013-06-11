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

### GIVEN ###
Given /^I am not logged in$/ do
	sign_out
end

Given /^I am logged in as a user$/ do
	create_user
	create_visitor
	sign_out
	sign_in
	two_factor
end

Given /^I am logged in as an admin$/ do
	create_admin
	sign_out
	sign_in
	two_factor
end

Given /^I exist as a user$/ do
	create_user
end

Given /^I exist as an admin$/ do
	create_admin
end

Given /^I do not exist as a user$/ do
	create_visitor
	delete_user
end

Given /^I exist as an unconfirmed user$/ do
	create_unconfirmed_user
end


Given /^I am on the Edit account page$/ do
	click_link "Edit account"
end


### WHEN ###
When /^I sign in with valid credentials$/ do
	create_visitor
	sign_in
end

When /^I sign out$/ do
	visit '/users/sign_out'
end

When /^I sign up with valid user data$/ do
	create_visitor
	sign_up
end

When /^I sign up with an invalid email$/ do
	create_visitor
	@visitor = @visitor.merge(:email => "notanemail")
	sign_up
end

When /^I sign up without a password confirmation$/ do
	create_visitor
	@visitor = @visitor.merge(:password_confirmation => "")
	sign_up
end

When /^I sign up without a password$/ do
	create_visitor
	@visitor = @visitor.merge(:password => "")
	sign_up
end

When /^I sign up with a mismatched password confirmation$/ do
	create_visitor
	@visitor = @visitor.merge(:password_confirmation => "changeme123")
	sign_up
end

When /^I return to the site$/ do
	visit '/'
end

When /^I sign in with a wrong email$/ do
	@visitor = @visitor.merge(:email => "wrong@example.com")
	sign_in
end

When /^I sign in with a wrong password$/ do
	@visitor = @visitor.merge(:password => "wrongpass")
	sign_in
end

When /^I edit my account details$/ do
	click_link "Edit account"
	fill_in "Name", :with => "newname"
	fill_in "user_current_password", :with => @visitor[:password]
	click_button "Update"
end

When /^I click the Reset OTP secret button$/ do
	click_button "Reset OTP secret"
	#page.driver.browser.switch_to.alert.accept
end

When /^I look at the list of users$/ do
	visit '/'
end

When /^I enter a valid OTP$/ do
	totp = ROTP::TOTP.new(@visitor[:otp_secret])
	fill_in "code", :with => totp.now
	click_button "Submit"
end

When /^I enter an invalid OTP$/ do
	fill_in "code", :with => "this is incorrect"
	click_button "Submit"
end



### THEN ###
Then /^I should be signed in$/ do
	page.should have_content "Home"
	page.should_not have_content "Sign up"
	page.should_not have_content "Login"
end

Then /^I go to the OTP page$/ do
	page.should have_content "Enter your personal code"
end

Then /^I should be signed out$/ do
	page.should have_content "Sign up"
	page.should have_content "Sign in"
	page.should have_content "Forgot your password?"
	page.should_not have_content "Logout"
end

Then /^I see an unconfirmed account message$/ do
	page.should have_content "You have to confirm your account before continuing."
end

Then /^I see a successful sign in message$/ do
	page.should have_content "Home"
end

Then /^I should see a successful sign up message$/ do
	page.should have_content "QR code"
end

Then /^I should see an invalid email message$/ do
	page.should have_content "Emailis invalid"
end

Then /^I should see a missing password message$/ do
	page.should have_content "Passwordcan't be blank"
end

Then /^I should see a missing password confirmation message$/ do
	page.should have_content "Passworddoesn't match confirmation"
end

Then /^I should see a mismatched password message$/ do
	page.should have_content "doesn't match confirmation"
end

Then /^I should see a signed out message$/ do
	page.should have_content "Signed out successfully."
end

Then /^I see an invalid login message$/ do
	page.should have_content "Invalid email or password."
end

Then /^I should see an account edited message$/ do
	page.should have_content "You updated your account successfully."
end

Then /^I should see my name$/ do
	page.should have_content @user[:name]
end

Then /^I should see the admin menu$/ do
	page.should have_content "Admin"
end

Then /^I should have the user role$/ do
	@user.has_role?(:user).should == true
end

Then /^I should have the admin role$/ do
	@user.has_role?(:admin).should == true
end

Then /^I should see an OTP error message$/ do
	page.should have_content "Attempt failed"
end

Then /^I should see a QR code$/ do
	page.should have_content "OTP Secret Reset"
end
