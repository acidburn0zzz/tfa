require 'spec_helper'

# note: http://robots.thoughtbot.com/post/33771089985/rspec-integration-tests-with-capybara

describe UsersController do

	before (:each) do
		@user = FactoryGirl.create(:user)
		sign_in @user
	end

	describe "GET 'show'" do

		it "should be successful" do
			get :show, :id => @user.id
			response.should be_success
		end

		it "should find the right user" do
			get :show, :id => @user.id
			assigns(:user).should == @user
		end

	end
end
