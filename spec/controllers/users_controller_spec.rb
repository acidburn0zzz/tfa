require 'spec_helper'

# note: http://robots.thoughtbot.com/post/33771089985/rspec-integration-tests-with-capybara

describe UsersController do

	before (:each) do
		@user = FactoryGirl.create(:user)
	end

	it "should create a new user" do
		User.find(@user.id).class.should == User
	end
end
