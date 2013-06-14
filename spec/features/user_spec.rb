#

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

def log_in_user
	create_user
	create_visitor
	sign_out
	sign_in
	two_factor

end

def log_in_admin
	create_admin
	sign_out
	sign_in
	two_factor

end

describe "controller methods" do
	before(:each) do
		sign_out
	end

	it "destroys a user" do
		log_in_admin
		@visitor = create_visitor
		@visitor[:email] = 'foo@bar.com'
		User.create(@visitor)
		@user2 = User.where(email: @visitor[:email])[0]
		visit 'users'
		click_link "Delete user"
		test = User.where(email: @visitor[:email])
		test.size.should == 0
	end

	it "updates user" do
		log_in_admin
		visit edit_user_registration_path
		fill_in('Email', :with => 'foooo@oooo.com')
		fill_in("Current password", :with => 'changeme')
		click_button 'Update'
		#page.should have_content "User updated"
		user = User.find(1)
		user.update

	end
end

describe "sign up features" do
	before(:each) do
		sign_out
	end

	it 'Visitor signs in with valid data' do
		create_visitor
		create_user
		sign_up
		user = User.where(email: 'example@example.com')[0]
		user.has_role?(:user).should == true
		click_button "OK"
		page.should have_content "Home"
	end

	it "User signs up with invalid email" do
		create_visitor
		@visitor = @visitor.merge(:email => "notanemail")
		sign_up
		page.should have_content "Emailis invalid"
	end

	it "User signs up without password" do
		create_visitor
		@visitor = @visitor.merge(:password => "")
		sign_up
		page.should have_content "Passwordcan't be blank"
	end

	it "User signs up without password confirmation" do
		create_visitor
		@visitor = @visitor.merge(:password_confirmation => "")
		sign_up
		page.should have_content "Passworddoesn't match confirmation"
	end

	it "User signs up with mismatched password and confirmation" do
		create_visitor
		@visitor = @visitor.merge(:password_confirmation => "changeme123")
		sign_up
		page.should have_content "doesn't match confirmation"
	end


end

describe "sign in features" do
	before(:each) do
		sign_out
	end
end
