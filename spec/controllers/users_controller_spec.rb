require 'spec_helper'

# note: http://robots.thoughtbot.com/post/33771089985/rspec-integration-tests-with-capybara

def create_visitor
	@visitor ||= { :name => "Testy McUserton", :email => "example@example.com",
		:password => "changeme", :password_confirmation => "changeme",
		:otp_secret => "lqdjuj4z6cvudk3v"
	}
end

describe UsersController do

	before (:each) do
		@user = FactoryGirl.create(:user)
		@visitor = create_visitor
	end


=begin
		it "should be successful" do
			User.create(@visitor)
			@user2 = User.where(email: @visitor[:email])[0]
			delete :destroy, :id => @user2.id
			response.should be_success
		end
	end
=end
end
