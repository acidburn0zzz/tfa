require 'spec_helper'

describe "controller methods" do
	before(:each) do
		sign_out
	end

	it "destroys a user" do
		user = FactoryGirl.create(:user, email: 'foo@bar.com')
		User.find(user.id)
		create_admin
		login_admin
		visit '/users'
		click_link "Delete user"
		page.should have_content "User deleted"
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

	it "User signs in with valid OTP" do
		login_user
		page.should have_content "Welcome, user"
	end

	it "User signs in with invalid OTP" do
		create_visitor
		sign_up
		sign_out
		sign_in
		fill_in "code", :with => "this is wrong"
		click_button "Submit"
		page.should have_content "Attempt failed"
	end

	it "User is locked out after 3 bad OTP attempts" do
		create_visitor
		sign_up
		sign_out
		sign_in
		3.times do
			fill_in "code", :with => "this is wrong"
			click_button "Submit"
		end
		page.should have_content "Access completly denied"
		sign_out
		sign_in
		page.should have_content "Access completly denied"

	end
end

describe "User edit features" do
	it "Updates the role of a user" do
		user = FactoryGirl.create(:user, email: 'foo@bar.com')
		User.find(user.id)
		create_admin
		login_admin
		visit '/users'
		#click_link("Change role")
		all(:xpath, '//a[text()="Change role"]').first.click
		puts page.body
		#page.should have_content "User deleted"

	end
end
